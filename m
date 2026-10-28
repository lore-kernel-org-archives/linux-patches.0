Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211447;
	b=1atD7v8/6z0bzHslC6hxrbgP1pEtBxzGT6Efu7Edjv6vRXEpF/JDtVfCcxzqD77G9H9G
	 aDwHcqj2Nf5bHcAlSQg3JhBOGBDfgWvQQeq0tXk+Wkg2uAwGtdWIf1+4E9SGXu79ZDkh0
	 dj9snNBOfV0pqN35QkPDz0lbq5SsFWaRXnAcxblSc1OO2aQ9R+4PyFFOvmFG7bThXhl82
	 9Q6NfSzI519E/o1wfGj6j4B7w2Z5Es2WGLz3AVBYgmh1rDL21yOgaKPJRj6tpM0Mu98iO
	 bGXw34IMl5ZfOnVWygnx4hjmlQkov9c8mbTnrFcwf0EPPue6MfIUvTHIrxypLSXVn6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UmNtH8sepr4Xwyy6jX1NTQ0e5KoQYJ1uT7bktSENYQ4=;
	b=2o5Bbr3SZXBrKKELlfs5FnzL4aWaJ/x5RD11PgWS81CLk698YwhhjJNyULwUsiKBcgdQ
	 GYHsO3WBJIK6f7csJPANfOOBpOUM3RiIskpfi0WMNbrJQx1VOxfEN4472CEdsuvLbRxLQ
	 ZwYzlvebq3+JIHOOCheaxVy8I+1DMsvSkP2wyh2vODp8fkN8nHP4ndik/kl8qLDZU0hHb
	 vHiqjB+f7oN1GkeWk3JiXFTkjWpBr8jzC8i/URDiUJqiyYpBCuK+xYlNyYd8CLop1mDGF
	 7cNBZMx2rTzjdr4HG5DWJHrmH0E9iLuPZnRwdxaSXt6iaE0sVPY7mdkBGc8u6jAghuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jpkzGxGD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A40606A323;
	Wed, 28 Oct 2026 18:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jpkzGxGD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14F51F01825;
	Wed, 28 Oct 2026 18:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211447;
	bh=UmNtH8sepr4Xwyy6jX1NTQ0e5KoQYJ1uT7bktSENYQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jpkzGxGDNDfHZmW0auy+bCWjXMUfe2ddCxj9fIuIN9EJC0yNssKU3PRW0F4Fbnzpy
	 avHhNPiSDHeB2OE8qEWvmmLFvGeRqaoPfN0dhKK0oX8nSrFTY/TUk1dNdQArRnAlGn
	 RtmJccKD0ojLM4DVdh9m8bLDuPWjbwRbW11XZEsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 5.15 382/571] drm/gud: dont keep a connector without a CRTC as connector_state
Date: Wed, 28 Oct 2026 17:58:49 +0100
Message-ID: <20261028170017.076911674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
@@ -475,6 +475,7 @@ int gud_pipe_check(struct drm_simple_dis
 	for_each_new_connector_in_state(state, connector, connector_state, i) {
 		if (connector_state->crtc)
 			break;
+		connector_state = NULL;
 	}
 
 	/*


