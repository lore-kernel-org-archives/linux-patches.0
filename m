Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213351;
	b=bH62qkkCtxzx7AzsyyKKDsyQ6DlvYKsq21imtuzGN+PMIu0TngauHIkNmKfprenMjyWQ
	 Lq9T84fy8zyGFV5fXTCOJa+MCmFf/+ON2RQakuKgWWYipwsirowN3t13cJHrosOgkrIC7
	 Z8BdUaUm4oJr3vLcb3nE2l4CDLfO81Bo9DhtSRSTchBhwLNWLCH+U835rt5bn91vQLnGS
	 paABpwt01IEQxLZ7gwGoyqsvKaunpB2NLrzfAk0EzhYwqKptVTV4Y6cb9gUVgohkQUhGj
	 MdySCd9NTLoxPPgwhdjWeV6LpmWbmSqTEwDYjLuFWjHYhEP1vAktzApoEn2CyCbyZCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5LvD7TzWgoPW8CrsUBs2uC4hJxPqaK32pJnn/2L4CJ0=;
	b=acF0eJtU1BjezgjFIYM/wuPHndrELSq4IhkeDeIXVfPIDiQufNnqkio4bayGsqgPWtNC
	 PFwHiC/9TZMlquB9/8xjmCtQS8M+Xe3ZZkaWwU8qvAENIp3hbntoMrFDS1SdeQgWSTXH+
	 xWjB27lSH4S+chZcpjl9DGwvu8Hzpz5EcTI3OzwHYHuKMiRAAmgIw8/rHgjFwOleJXpgP
	 Ea6mVll7wZ7YQYAIfpZChYJvxvmgGd4zxbua8RFHhnqG7mXQRes8zYsmIrF1RJW0FjcEH
	 lMxQ3CM7QmyEZ0eCDok+xACrDdl13XSA2TsY2q/9f2GpuoPEQfOCTpTW/ydYjeR+V/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KcMZKAKY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CC4606A31C;
	Wed, 28 Oct 2026 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KcMZKAKY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9694B1F01825;
	Wed, 28 Oct 2026 18:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213351;
	bh=5LvD7TzWgoPW8CrsUBs2uC4hJxPqaK32pJnn/2L4CJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KcMZKAKYapt4fTxrf8/Zj3MWd7dIRud1/obmgCk0wHLAUVnqyzSOEmL1tSig4+7JK
	 njEvoBJO13pvv0ywaPcPfFypAFg4ZcVcgF+5+p08gL9wT/vFARre+NV39dCJfn9uhW
	 MFclcL6ymq0cH3CsE4UWkPoNklgEww7lRkLpclks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 6.1 0474/1887] drm/gud: dont keep a connector without a CRTC as connector_state
Date: Wed, 28 Oct 2026 17:42:50 +0100
Message-ID: <20261028170510.029126793@linuxfoundation.org>
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

From: Sajal Gupta <sajal2005gupta@gmail.com>

commit 71ec70ea26e399eb8371fe9d2d5bf5dab09570fb upstream.

If the 'for_each_new_connector_in_state()' loop finishes without
hitting the break, connector_state is left pointing at the last
connector visited, which has no CRTC, instead of
staying NULL.

That skips the "if (!connector_state)" fallback below the loop, which
looks up the active connector when the state contains none. The
function then carries on with a connector that is not driven.

Fix by resetting connector_state to NULL for each connector visited that
has no CRTC, so that it is NULL when none was found and the fallback runs.

Fixes: 40e1a70b4aed ("drm: Add GUD USB Display driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260902123254.36987-1-sajal2005gupta@gmail.com?part=1
Signed-off-by: Sajal Gupta <sajal2005gupta@gmail.com>
Acked-by: Ruben Wauters <rubenru09@aol.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ruben Wauters <rubenru09@aol.com>
Link: https://patch.msgid.link/20260922084026.15481-1-sajal2005gupta@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gud/gud_pipe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -489,6 +489,7 @@ int gud_pipe_check(struct drm_simple_dis
 	for_each_new_connector_in_state(state, connector, connector_state, i) {
 		if (connector_state->crtc)
 			break;
+		connector_state = NULL;
 	}
 
 	/*


