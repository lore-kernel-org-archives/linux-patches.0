Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831769;
	b=hADlj0p8KbjYSCUIo4eoLDYhqVgcANGnJDyXz6GGR+BRKBNtIMcu7k2zmwalzkzOTfrK
	 LcTez+D/AVWEw6JYxcnFIeadyfz0mdqr/n/rm8NAOm/t5Yp3JdXTIg8W0q3wf6MOSxjPM
	 6v2ATOCHjK6I+7mXON8fEZJSOU8AmN52u+ryGJO8Zp5NVm3yMOHCpNq2hP54VHWHwwdkx
	 Qm89g49mFtxGWvQbxQxOpibj0sbp+GmBD/r2N+08AqvhLFGEQAJ9h5f4YYTuPk1UdIx/W
	 D9iogKJ39LlOBh1ig2DH5egG42MvmAHBzSGNFNZWsaU4rItc5WKnvIkbN7vAt7jgLpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Rxb/GtP4plsOHQjW8nOxEZzHWdyqeWoHXdpIpd/8P4=;
	b=0XTVmR63lJElpAFXXpraEahXV2i18UteJjOHNZNtUyYvQlkF3Lyln+PPq79C6CX9oYzj
	 8ZX9O0tPrNaf+O1xKyGyGoxJdVrBPzTCceM8ZSPfCNEUWDQBQLU8Ped3ylYdD3wK75RdV
	 VhE7+fS8lWhkiZvJ4gBJE80fOeuHYKu9dLxcl2vJf4Sz76xAdTVLxw1aR3INl/jaVVHe0
	 DYFu8OilAl9iPSW8kdDG5O23aXAyznaZ0m/gHQftGsYJTcZ/FLuo4c+rimCf0maKfOnIN
	 Vz8ERVMsvI1HW4b94ViSteiwWcnrOjlPLZ3FQV38TQZ6PIT8r2Ns7k9sqd0QN1XyS7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SVlveqtu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185A8606A31B;
	Wed,  4 Nov 2026 22:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SVlveqtu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D221F000C1;
	Wed,  4 Nov 2026 22:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831769;
	bh=0Rxb/GtP4plsOHQjW8nOxEZzHWdyqeWoHXdpIpd/8P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SVlveqtuMKZCJgZTzinSQnIGT7PACIYbDCiShHyryDRzRkgUGVHc0zO2XGfcRJPfV
	 1u53e+Hu1ocnA3mftHEgf9LtIL47GV6aJu66WlKR+VbmyH+mFXNRKUzs4L18Qa3/VA
	 Sfz3jBAlgwcuAfHF9vJzRo4dIwJ6uE51NNjm/jTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0901/1005] NFSD: Reject an oversized principal hash from nfsdcld
Date: Wed,  4 Nov 2026 16:10:34 -0500
Message-ID: <20261104211108.432709668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -790,6 +790,11 @@ __cld_pipe_inprogress_downcall(const str
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


