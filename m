Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048902;
	b=sZ4tf++EAgXmgDHeZhU9I6/6AeQx/eC2aOWLsH4mGD06YCmFKFNuWE4c8BbyrUKp2dkE
	 So7pDD+NpivUFZnp4pqSuwxe+kNowuubK5Z/0HBpk4YCWejCQZMlZ/y99+A39pLerOB13
	 2JV8mn+qtP29rjrcETPZKAbEWcI8RK2Q+xmbLodbcYiWGck8XVNm6pzc526sjA0nrQNYh
	 HHn1mImQTgyp/wNJgRkS+EwSsOCCU2AAPpPDY6/ZH18owyKzFf4C3uaCdTl4+T4u/hJ0d
	 a7JIfGKsjCmjXc7euAs5g4T+nuSyFU+aaGrkhRK5/OWru7zeQkEQ7zIB4G9YM342JWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MR1CUbSUy/JIAxJOosNJaOAagRHUxaPH5LCpM8DybxM=;
	b=NwyTC1ELPNthL0j4KwHaRTtXVQTIIkwrkzFh2q1itFQpQ177ipndx9hRb9yK5rfg7o2j
	 Yd8I/QtEz++niPy8heir859Vezrr15ouIVVjjJCRPbNBOlPsy7SJFU4HRBUgk+ZEt29QS
	 qoVkfWPROAHbut7NZS3RWSeGIkvnN2sbnffI8onM5gTlcW29tCoius84aH0+5kmJybQ6p
	 CUtfaIEw3TgFK0IWcboHWYI8AtcESuNiAaoGcTj5k4Tqpb6YLjet3qLFFoTj9bP28lsaQ
	 I24yRdF1AJEhUVTC9v4MRku2oL45J0Gb7CRUjmVGxuzPzkKtNtPOrhHM8OIdvlZnK0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h41dVDXX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC85606A33A;
	Thu, 19 Nov 2026 00:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h41dVDXX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656711F000C4;
	Thu, 19 Nov 2026 00:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048901;
	bh=MR1CUbSUy/JIAxJOosNJaOAagRHUxaPH5LCpM8DybxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h41dVDXXQIvYd3S2IJESKYIMuGf7SsHH9w+w2TLXc2Gy5Vh44TypAuvSvSP6W5tt5
	 SvqI3xGuRGZIoGxygYP0HpPWFAxwB5gYh+bB9OVGRT7m9RSJOMEaHMqrMrpQ9s+J+6
	 Y8Lmefv0PhZ8Cv4Fv9eI8sqTdiF7xdEKE5yP1blI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2158/2857] OPP: Fix the return value in dev_pm_opp_get_of_node() kernel-doc
Date: Wed, 18 Nov 2026 15:53:12 +0100
Message-ID: <20261118150319.094729960@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 706081c6b9327dd611dd72b20130a77f0f059b6e ]

dev_pm_opp_get_of_node() returns NULL when the OPP is invalid, but its
kernel-doc says "else 0 on success", which was never true. Say NULL.

Fixes: e2f4b5f8dc59 ("PM / OPP: Implement dev_pm_opp_get_of_node()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index c09e05c5a5711..fbaa88c47b2dd 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -1435,7 +1435,7 @@ EXPORT_SYMBOL_GPL(of_get_required_opp_performance_state);
  * dev_pm_opp_get_of_node() - Gets the DT node corresponding to an opp
  * @opp:	opp for which DT node has to be returned for
  *
- * Return: DT node corresponding to the opp, else 0 on success.
+ * Return: DT node corresponding to the opp, else NULL.
  *
  * The caller needs to put the node with of_node_put() after using it.
  */
-- 
2.53.0



