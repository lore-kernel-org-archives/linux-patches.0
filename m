Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060818;
	b=mh8S1/m+zgMfbPEgEapARLDyzxkoWJnMm6mkuzRG8JSnpFZmVYSKPofnqNXizNa32/+1
	 vwQtd41spzYawy6Fe/gonNlWsuwPKApEq+Yi/3VG5aYTJbl2J+ZQH3OfN4h5KVoqAy4Q8
	 bM2s3biaE7GYKcGLfEcdzOugY+u3B79AYKhIF7ufvel/1RVlB2TT1deFuSEVQsFAM9gBH
	 8+u0p7Dm7KFajfhubmGtA70Zl3Tzw0NE0GW1T8OtEZSNCB7b6gLlhjYDXyBgpnMew7+aE
	 bi2bpqxKO7YzDTTCjHX6Unr+FFmyO4+EMWbag0gaS9PjBZQ7nYN64UFH9Y5SeaQwCxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+xPb43924wus64/mtOlUOPlN2M2NfDtgufqP0AbLatk=;
	b=mG/ixpaDjOIIOSAe/2o0+OFcnCFXOmwi2ViDmHiBd/Db9gW5IHMgLtcXRrFDE/CjZppx
	 op1dj/shqMQVHLYthfluC5T/gfwzsYg5T13hwoghplAW2z55YUtdkUIkJr7FpWvfo3xd0
	 hmEvTciXEX6COzk4QqJ7/DWtSV2SVe2CLcUkJRHLkQgrKirB5fu+mhD5gPSqpa1hSk6Tr
	 SgCRyfneKQfytnK1AsU53z7cE+ytbAJZiQhuGLURCJU6Lwn9S2nMeyW88kUJqGFgWJp43
	 aickTgzGZXTKTgAl1Z8RWmzlLIAqoZhWd6zDJzbFEG9hyfPbTGRduzIqVu1T0OQozCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMC0GSuh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D841606A326;
	Sat,  7 Nov 2026 14:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMC0GSuh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7E61F0089F;
	Sat,  7 Nov 2026 14:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060818;
	bh=+xPb43924wus64/mtOlUOPlN2M2NfDtgufqP0AbLatk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMC0GSuhcI3iwHRSoKrF4JKsDuw5Lj3f6cNV5rJU8ilnPnUlWtCgCwsv0XYmFlsC5
	 2s08wWbu2Udtzeo5UKNaBOtq21K0uv5NsWukR/MQBd8H1WIgHvhIZNPdwTJJwPmuiL
	 rLyA59lMVkedMlrlHXqWgRRtjoAX2hekoeyh3+CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0216/1536] scsi: ibmvfc: check for NULL evt in implicit LOGO and target delete path
Date: Sat,  7 Nov 2026 08:37:12 -0500
Message-ID: <20261107135003.723062595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 0122eab60b151d7815f420a91c7315944a037714 ]

Unlike ibmvfc_tgt_implicit_logout the ibmvfc_tgt_implicit_logout_and_del
path fails to check for a NULL evt returned from
ibmvfc_get_reserved_event and passes that directly to ibmvfc_send_event
which will unconditionally derefence the evt.

Check for a NULL evt and perform same escalation as
ibmvfc_implicit_logout.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://patch.msgid.link/20260723000149.969416-4-tyreld@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 459cc8a015bc1..63cd0bab785ba 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4401,6 +4401,14 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *tgt)
 	evt = __ibmvfc_tgt_get_implicit_logout_evt(tgt,
 						   ibmvfc_tgt_implicit_logout_and_del_done);
 
+	if (!evt) {
+		vhost->discovery_threads--;
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		__ibmvfc_reset_host(vhost);
+		return;
+	}
+
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT);
 	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
 		vhost->discovery_threads--;
-- 
2.53.0



