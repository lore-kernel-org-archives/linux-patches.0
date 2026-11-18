Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030806;
	b=GJUYwgl6LkiTlmSyZnvEK4jm18WMZkXxCeJ9qu6j0NOwDUCgydRUaOx9P997CTskT0cD
	 +38WtQs4WMmIRvFwgqAbDhKEgj31YdKnl+MbnaJfB1GGL9DXmuUGxB2A/1Rsp0gSphLxY
	 duvYt2i4aWVrbbqB7SCyzWb9l3BWLMtxceqnKDNX0eDT4rIX+BMAn9KuYUu9hodefy1D/
	 grqazyrplcHTHYOasTcqHqWu6d0Y9Bs1mxBStvAfeHdEpcw3od1rAuypsSlezDp/C586G
	 SXWTid+cC9aRP3R/kqEjt2ULcwuy0AA9lvjgpOD8O4HP4WFftATVVgmzfu/VB9kQ5MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N9H7orIPSbJfNwk8ePLdYG9zOCmrXKMmtO+xBVHcBYI=;
	b=Affsz6805HhVuKq2afVTtFuYDZfrqBb0PycPTYVvznh/sCqQPVwg5jAhXlGwvyQGRZ6B
	 XLvkiKT6uidExtPHPAkfEkWVE90dBEdZfRbANdnRH7X1j7vK5TBvx4iYaCj/pK+7pV6N8
	 WIp8UzjU1asKXjO0LVDaRYMz3EsH1uPShPVh9K1J9L/SsoD6XnQxBCZc2vcZM24vukYMR
	 vMnsE5t7Hz6om6omVYNMTym8XqgcTIrQx/kfNj81sc+UHzkyzoJmLJIULRbaIEwCJGC3r
	 wX8hRZQSuxN2nRdQv73eGHUFIBg8zmd7gPTmRYdZgtrRkscrR8ALCFOPjHI76oHPaYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rmjAScW5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC9F606A92E;
	Wed, 18 Nov 2026 19:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rmjAScW5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6676F1F000C4;
	Wed, 18 Nov 2026 19:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030805;
	bh=N9H7orIPSbJfNwk8ePLdYG9zOCmrXKMmtO+xBVHcBYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rmjAScW5jX5/9UL643zjeSjESdLCrlaKqVM1IHhUU0QXp8+idb4MCSDu/GGH9ILGo
	 4xq0gZtyPTNWMezlkUaN1INM2Qu+F3wguWYKTXpsYfTM7FUxrjEONRIGw5XoXF5a6N
	 4xfaBx6CvWiHpeoSn2eE783cYlLziwJxKCmSuRDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0794/1756] scsi: scsi_debug: Take the zone metadata lock before the data lock
Date: Wed, 18 Nov 2026 15:48:41 +0100
Message-ID: <20261118150041.318702838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit c9aedbcbff0fe31fabdea09600609eb30e05441d ]

resp_comp_write() takes the data lock and then the zone metadata lock,
while every other command that takes both takes the metadata lock first and
reaches the data lock through do_device_access(). A COMPARE AND WRITE and
any other write to the same store can therefore deadlock each other.

Take the locks in the same order as everywhere else.

Correct the comment above map_region() while here: the provisioning map is
covered by the metadata lock rather than the data lock, which is why
resp_unmap() takes only the metadata lock.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-19-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ee129f23a7c58..289f298c759fc 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4756,20 +4756,20 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 			    "indicated=%u, IO sent=%d bytes\n", my_name,
 			    dnum * lb_size, ret);
 
-	sdeb_data_write_lock(sip);
 	sdeb_meta_write_lock(sip);
+	sdeb_data_write_lock(sip);
 	if (!comp_write_worker(sip, lba, num, arr, false)) {
 		mk_sense_buffer(scp, MISCOMPARE, MISCOMPARE_VERIFY_ASC, 0);
 		retval = check_condition_result;
 		goto cleanup_unlock;
 	}
 
-	/* Cover sip->map_storep (which map_region()) sets with data lock */
+	/* Cover sip->map_storep (which map_region() sets) with the meta lock */
 	if (scsi_debug_lbp())
 		map_region(sip, lba, num);
 cleanup_unlock:
-	sdeb_meta_write_unlock(sip);
 	sdeb_data_write_unlock(sip);
+	sdeb_meta_write_unlock(sip);
 cleanup_free:
 	kfree(arr);
 	return retval;
-- 
2.53.0



