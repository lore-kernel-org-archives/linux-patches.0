Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063612;
	b=pwFUureU7kfyPikzVI7aMPickxrE7RmYV2BQ2IqDKiUp5uIAT+uu/82F0an5ovWtTRok
	 2IP401CWmc+dG+xrzBx7ssh4T2Rt5G5/3VhUghczEwj3hXYcprzSfkZNkC5E4Bwt1UdwB
	 /H6IRDWCRuNi3MScjtAUZc4H/iADSMKKWBnKORW3S2w4M+SAOB6qAwczDFOT6Xo1CWuPv
	 XH+ynPr/qK4Ikp3z8hbIS4F8zK/QFszYsd+rtu4gpOxO4/ueQBoOU4Ia8BLcucTYE184P
	 x2LxeqaNVyNXpcx561CzjoBWVbFf6uOQZj0aOJFUsrHlICFmgaqNA+CF44UKudL5MSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JeEHEL5ZbZrtaU6iKeE77ck2wkCJrkY0/pZYvMRz1cA=;
	b=PjaHR4OIe3xQmmmjrrjb0CuQ5nPQJhlgG9aCRgtivWRhzFb42JnLsPvBF4ILomecqw+y
	 0QI9GcDvODuG+/7xFFa8wOtBrQwYDsCjEWn5t31UBFt+bFV1seVkLwLRpAkU1mX1R2bTy
	 2115kI5CKAE+vdZoqWZQwmqHp7UGkyCRWwkcxnCQL9NbLGjXIZM2q/O6I0iyWQbaOGoWn
	 ExGA9oFNqn7By2EKZhO/x4jvTV1p2dIhIfVB8x06+B6l5DyyI7myWHlVozxORv9OInSfB
	 AQ0/KftyDMZIsPKx/5AkmlRue5g2o2IaoJsLBW1G4jgIE4UnXM3obnVTat49wc1vWDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LP3yiS9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E6F606EEA0;
	Sat,  7 Nov 2026 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LP3yiS9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473611F0089F;
	Sat,  7 Nov 2026 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063612;
	bh=JeEHEL5ZbZrtaU6iKeE77ck2wkCJrkY0/pZYvMRz1cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LP3yiS9GoWuO/2XivPPC7ncO3K8ZGEWu3kELHM2iW4nU/frcLuRSMGi/jlNvgHr6z
	 ya5kcbORe+ctey8Unr/ET4X2jXm9/n3rA7p0WjR4rL09RjH9Dufr3iYm8C/SCoMZzp
	 4coytK4LlwGGMX2nkIGQAiH6GhyIbJQz/dIMKF4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 734/869] scsi: libiscsi_tcp: Prevent R2T range check overflow
Date: Sat,  7 Nov 2026 08:56:56 -0500
Message-ID: <20261107134917.736972136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>

[ Upstream commit eb7aa7fd673fdc1582223cd133bcc5f54e7af19f ]

An iSCSI target controls the R2T data offset and length as 32-bit
values. Adding them before comparing the result with the SCSI data buffer
length can wrap. An R2T with offset 1 and length U32_MAX then passes the
check for a 4096-byte write.

The transmit path treats the wrapped range as valid, exhausts the command
scatterlist, and dereferences the NULL next entry in
iscsi_tcp_segment_done().

Check the offset first, then compare the length with the remaining bytes in
the data buffer.

Fixes: a081c13e39b5 ("[SCSI] iscsi_tcp: split module into lib and lld")
Cc: stable@vger.kernel.org
Signed-off-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Acked-by: Chris Leech <cleech@redhat.com>
Link: https://patch.msgid.link/DB5PR08MB100629CD3750FBF71475B5224FD982@DB5PR08MB10062.eurprd08.prod.outlook.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libiscsi_tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index d35f93451ee9b..3c9e736d45e7e 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -601,7 +601,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 			      data_length, session->max_burst);
 
 	data_offset = be32_to_cpu(rhdr->data_offset);
-	if (data_offset + data_length > task->sc->sdb.length) {
+	if (data_offset > task->sc->sdb.length ||
+	    data_length > task->sc->sdb.length - data_offset) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", data_length,
-- 
2.53.0



