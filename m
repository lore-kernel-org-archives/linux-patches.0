Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73E11649BA;
	Mon, 29 Jan 2024 17:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548435; cv=none; b=YZooN8nMmPYTak0kSY1v6CLF+r2wzrDtT9oSDvXRTxYwV2Fn6YxqOcmQbtTwC1xrjPIaswxtXxxmil3Q4yuewim0eBKfo6TDevUsTI5FkVsv9VrGl/7ciqexOIWE45f4PeB6AxPfSaKst3KJ1RulvwLrDqzZG1tYXN6hRpBmito=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548435; c=relaxed/simple;
	bh=xiuG66K/hnT0/ziSZfk0Y2XbdkPGl5BGVj52YcFwXp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eH8AVcQ4EAA69i2kQY4Eu7xomQOrF4Jut0Ejj5Ofpje9f8lT5uUyCjtchlhKpWWChClQn2ujxnBVXyIJkbQs+g5JkBX9GAqE29PoXdM/Pns2kDBHSzOOmamHOTLRy0RRdYuLt1XK5EOqY5ClK1nxGt09Tl8f0OHLQYqXAbbDqG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whjTTdfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whjTTdfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0A7C43390;
	Mon, 29 Jan 2024 17:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548435;
	bh=xiuG66K/hnT0/ziSZfk0Y2XbdkPGl5BGVj52YcFwXp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=whjTTdfphvVmGZcIAKBaMAGKyBVmqramuRIMYCGGCNaaHKjve5B8MTHQEJB4ueAgz
	 ILlMjqTGYwl5Z7PMQSM3lv/t/0nYqUu+VkRbPQq+ZXxW7F8ezFmsiAkq/vGEFxFAOi
	 OEWl7cmTF1eEVEJ+FHWGCl5DXMbdLALDhUVCWFv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 039/331] crypto: api - Disallow identical driver names
Date: Mon, 29 Jan 2024 09:01:43 -0800
Message-ID: <20240129170016.082402903@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 27016f75f5ed47e2d8e0ca75a8ff1f40bc1a5e27 upstream.

Disallow registration of two algorithms with identical driver names.

Cc: <stable@vger.kernel.org>
Reported-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/algapi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -341,6 +341,7 @@ __crypto_register_alg(struct crypto_alg
 		}
 
 		if (!strcmp(q->cra_driver_name, alg->cra_name) ||
+		    !strcmp(q->cra_driver_name, alg->cra_driver_name) ||
 		    !strcmp(q->cra_name, alg->cra_driver_name))
 			goto err;
 	}


