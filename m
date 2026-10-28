Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212331;
	b=lx3adnjLRCjZOWFvN6wsMPN5k0zYi6dGH9oH+gdhTnx5picuKjepgGCLKyW9DFMDnORE
	 OUZBN8ZAAYFGknNE/vYiUPGM709bqPrqy6/NJJveS8JfA8Uy/LTIly8e5mMSRrjJqOqVx
	 1YLpJPAbdm1FsJ9q6OMAPM0Rvb3btopMlMfTZX9RuR5NilNuGXrEphUXWo8crStcwPsNI
	 qUMdLEDZPPbmKSKM9W5KiGQ834ZoYtFId9UG3XOwJpKvAvl5KFpMmz8V3sezMea4dkaTc
	 Torc1b/5f4NM1diibw7d3asPCDULnOmSTH5RXqsuSV3c/FjGI2r19v11/F30qWppcsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dDF7XRIwXHGz0LYEFpVYV00OjUcj0Gbj/jcw+oIrPHY=;
	b=DQI/csnLCHJ9Y7KxmLuApolsFeSq6tjjvV7EuVaoTxeV/diHQOZ/SdSynb+xFB2ivqj3
	 pHISJEPnjpy+C/Nj+9tIKv+xEhW1W4KnTm2ThEWfOfCQTnTtTz9cnkcNPdRi2jjZiR/ED
	 XRTH4qztpe3MZRPWv2evw0oZ9LsKy9nxCwU5si7eFiS5lEJMSEMiLgKUqeaEC38mTjF8n
	 Pr3382E1p33pvIwE03PrU41ULN/mviTS2WM0mFoCL+N8Ux6paitgUhd4U/rXMSiY2jvmJ
	 OCIecw2vVmCjlcKN1o8Jzxw17KJdKWusoJ9PIL9P/NoquW23n7+nt8hyTmnkDhSXCZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ztt9zLmx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A564A606A31A;
	Wed, 28 Oct 2026 18:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ztt9zLmx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D291F01825;
	Wed, 28 Oct 2026 18:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212330;
	bh=dDF7XRIwXHGz0LYEFpVYV00OjUcj0Gbj/jcw+oIrPHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ztt9zLmx3viKeGJM55O2FxW8+/PduOPoKqK4NrHhCCi7/UOtHEJI9eFYe00T70W9P
	 0Lz2K0VjpDZ1U2sMTzA0oU8Mvu7AYUeRr2VHR7QzPW3zj+UZcypGSIAntEYOZtNSeY
	 kki2lam2RoeLb8sVlX9oVLacpDKTOBvCoiG10Znk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0109/1887] scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate
Date: Wed, 28 Oct 2026 17:36:45 +0100
Message-ID: <20261028170501.715865475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 52fba32317ee631faa878725b2f7cd5c08acacd3 ]

qla2x00_get_data_rate() skips updating ha->link_data_rate when the
firmware returns mcp->mb[1] == 0x7.  That value was a legacy sentinel
from before 64G hardware existed, but PORT_SPEED_64GB is now defined as
0x07 and ha->link_data_rate is decoded with the PORT_SPEED_* encoding.
On a 64G-capable adapter a genuine 64G link is therefore dropped, and
the port speed is misreported (port_speed sysfs, fc_host speed, FDMI).

Only 28xx and 29xx support 64G, so accept 0x07 on those adapters while
keeping the legacy filter for older ones.  Also drop the duplicate copy
of the check at the end of the success branch; it repeated the first
assignment with no intervening change.

Fixes: ecc89f25e225 ("scsi: qla2xxx: Add Device ID for ISP28XX")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-46-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ Omitted IS_QLA29XX() checks because this branch lacks 29xx adapter support. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ee22639fb54b8..583585783893c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5656,7 +5656,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 		ql_dbg(ql_dbg_mbx, vha, 0x1107,
 		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		if (mcp->mb[1] != 0x7)
+		if (mcp->mb[1] != 0x7 || IS_QLA28XX(ha))
 			ha->link_data_rate = mcp->mb[1];
 
 		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
@@ -5667,8 +5667,6 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1108,
 		    "Done %s.\n", __func__);
-		if (mcp->mb[1] != 0x7)
-			ha->link_data_rate = mcp->mb[1];
 	}
 
 	return rval;
-- 
2.53.0



