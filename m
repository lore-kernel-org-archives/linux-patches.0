Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044575;
	b=ILh6aiJfvpXoSQpxyjF5TrT3CEVHxqpQMG5JaH5cNaJPu68jSAPTtTHi+56JhK8lolzx
	 Jn0s2JuAqzfmUO0QwmUHWVOqi84H4jzvYiTZG5NvxWId1oEqG/BF/HMVTBN0a6hqHYJzq
	 50t/tp/yCOGs5Ltez2cZS2w5fED01Q9jYxUL26cgtyEf0nCHxPBB1D3oem/VuoJSlVUHR
	 9ryVaiI5J/O3+Ub3S+kIHZAdevZgdrWy36GqQbCXVc3opDRFI9cSee1Z1CAsu97oO/Yqb
	 0x8YRC1ZzA87/6K8jNiOaztLWPAQIxp8J6TQE+kujYgHB6sZAP8JXVep9jsTXCNcCgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FpPi0+z2u6wFXVKrZmYnlalxXKQse4dwq/aDOvewKco=;
	b=0Mez2Tm62adrTr1sHQKEL+V66eZcpGfsyFOetG+i69pTXhyGawVaKPMvd/vKcaEHqzZe
	 LQBlJb1TGUnycXuaP6s+4aemB207kLUAuchQpg2b9M+D34JlYRfw3CWIoUrFsXrrujUIU
	 dzq77igE+mk5MCoicHSqjvOH+R9U/kny8TQjj/17IlExhIk2NUanzDoVIg8TbH2IaQnBa
	 ZZbSo1NBkv2lQjBwXvAMR6ufaIQrbPB1YPqiFhwrOZn9lL7CfwyIs0NljuTmatvd+rv1b
	 mkWpBmw75epEjEfEtUFjhznrmtOCQOyk2ub1jrKIVEBmFROG5Mi0TuBJBGryxbp+9yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BTSq/qaT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9CC606A325;
	Wed, 18 Nov 2026 23:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTSq/qaT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3ABE1F000C4;
	Wed, 18 Nov 2026 23:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044575;
	bh=FpPi0+z2u6wFXVKrZmYnlalxXKQse4dwq/aDOvewKco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTSq/qaTBwiUs8JkY2PY0Zmtv9Z0MO2ziK/Gk0A1LT9tXL+OmlYLRcS4gu4vF0y3o
	 5n7kGH1F/m35F8m/KTZMSiMZk/jJkvAXWbA7F+O3TQad7UCY58PPIU7F7Bl165R+FM
	 j9Xq5s4LsCBytf5YTwNPG5XC2SoKouGpshXBGoEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0614/2857] NFSD: Reject an oversized principal hash from nfsdcld
Date: Wed, 18 Nov 2026 15:27:28 +0100
Message-ID: <20261118150223.600134964@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

commit dbed9418c48906dae1a7bc328fb3bc0d0d0020c8 upstream.

__cld_pipe_inprogress_downcall() takes the principal hash length
from the daemon's GraceStart downcall without checking it against
the cc_princhash payload it describes, which holds at most
SHA256_DIGEST_SIZE bytes. The length is stored verbatim in the
reclaim record, and nfsd4_cld_check_v2() later hands it to memcmp()
against a digest array of SHA256_DIGEST_SIZE bytes on the stack. A
length up to U8_MAX reads past the end of that array, and the stray
bytes can only make the comparison fail, denying the client its
reclaim. The pipe is mode 0600 in rpc_pipefs, so the trigger is a
broken or hostile nfsdcld rather than an unprivileged task.

Reject a length larger than the wire field, as the existing check
on the client name length does.

Fixes: 6ee95d1c8991 ("nfsd: add support for upcall version 2")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-4-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4recover.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -806,6 +806,11 @@ __cld_pipe_inprogress_downcall(const str
 			name.len = namelen;
 			if (get_user(princhashlen, &ci->cc_princhash.cp_len))
 				return -EFAULT;
+			if (princhashlen > SHA256_DIGEST_SIZE) {
+				dprintk("%s: invalid princhashlen (%u)",
+					__func__, princhashlen);
+				return -EINVAL;
+			}
 			if (princhashlen > 0) {
 				princhashcopy = memdup_user(
 					&ci->cc_princhash.cp_data,


