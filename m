Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052806;
	b=236et8u3of156vGqPQpmVVCNM+0Q6mRZHlXSnKG/2aW5RADFUtXIAw8dYyw08eKTh8yB
	 7Ir3c+rWgFPuwzCWcmunWEEkuppOMoyQ+7xO5wcgO6bwYsKLBufjjXFAKg8Oec+FdsT/N
	 NTjpN8gFkY1PU8vY2d5pRyH6ch4abk9hOzOK/P5FeHJFJJgGrsrhL6a4MooHtiJQhh4Za
	 5xLJiX9lUzfXvwq+dixXYGi82D9gR3MlPy72/BzS0NCefoBCZ4ubR0gMbbyhchi64b9SH
	 KDMwlxwyvh1zqvCwTetf81pZFOL5oLemSJwtdTZPBAucOSJgYMODXYfT1TSdlMR8Mtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VTK3e5yDalQgR+q0RUfiIzgxXCMUVaejm54N4H3omRQ=;
	b=a0ydCUZPXj+Rniyy3P1Lx94wUqXsp5g58r5kdQyKhXIc9FQ01LzkMj3s9gQ8dY+wZdmv
	 Xra8k8hjXZYTXa9rc4qBFwb2KroFROlFNNAEJUUUdQKxoMaIucHdVYP2Js4+tcio/8iuu
	 rBWgU0Kd0GJ+W6MwMJVeMTn5qIxvvK7nOrYHKQC9Vwrrno782kzwmSzueOEaj8jYQwZ/h
	 oMUCtKYbBLPS1wsmNZ34C6e2n/LR67DbOo3M1st5rdk3bn/WjXlFUFbC38XR8KhFIltsx
	 7KOv1+k2ynZVNEAe1XrcXRTLDIB3KyoB3rfsvuEJiZBspZUNUY/vyiVng2JRDMy1CHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeSX47DP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4807F606A31C;
	Thu, 19 Nov 2026 01:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeSX47DP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5C21F000C4;
	Thu, 19 Nov 2026 01:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052805;
	bh=VTK3e5yDalQgR+q0RUfiIzgxXCMUVaejm54N4H3omRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zeSX47DPMmWPwZyty/5ivv21liKvHiLhUM0z/zfB9GzNBUtZkrkot4q7OKdtu/7Vz
	 T6GuhF/TSBa15S4TGI2VHtoU6nepWrEY0IgYgI5hpIDYUYrLnWw6SlQEX6ab+YVAIq
	 qW2eMs9xyM0BrS+ULZGiHCrYlG8vu9GsNwU5Yk2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0696/2214] tpm: fix zero-length read discarding the pending response
Date: Wed, 18 Nov 2026 15:39:32 +0100
Message-ID: <20261118150039.669676221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 6fc1b05077b8ac7c3193616f0bc419f6185988c6 ]

POSIX requires that a read() with a count of zero returns zero and
has no other effects.  tpm_common_read() treats such a call as a
consumed response: it marks the pending response as read and drops
it, so the response can never be retrieved; subsequent reads return
zero and the next write() is allowed to overwrite the response
buffer, silently breaking the command/response pairing of the TPM
character devices.

Return early when the caller passes a zero count, leaving any
pending response untouched for the next read.  A zero-length read
will not report a deferred asynchronous error; POSIX permits read()
to skip error detection for a zero count.

Cc: stable@vger.kernel.org
Fixes: 9488585b21be ("tpm: add support for partial reads")
Assisted-by: GLM-5.3
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/3f15140ab3c26e98b49d6aceaaa826585d56960b.1791015549.git.xiaopei01@kylinos.cn
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm-dev-common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index c3fbbf4d3db79..ff86a1fdb5cdc 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -131,6 +131,9 @@ ssize_t tpm_common_read(struct file *file, char __user *buf,
 	ssize_t ret_size = 0;
 	int rc;
 
+	if (!size)
+		return 0;
+
 	mutex_lock(&priv->buffer_mutex);
 
 	if (priv->response_length) {
-- 
2.53.0



