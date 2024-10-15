Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753B81C07DC;
	Tue, 15 Oct 2024 13:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997563; cv=none; b=a+5d8DJ0CltCYRRKy1Dx+2uutyxgpTTGuEhK2JuZlLTnIDl8F5mJY+Mwfyy6EP1xrTRPzg+a0oZZgBHmWtE0CVEidZnOfum1URkhIPjNi0NUe44PyHxLcaxT4z16PquZm0gSnbG5I5XmDpumzEMNDFEwCMByXLwejn3Skb3Oxig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997563; c=relaxed/simple;
	bh=Ug44KSDzfzhc1u5CWD3e9gYXrmDKoA/YvEPj8cSl86w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PORinTCnBc1eAI4dq37WOMxJJXFuQUrjMoZPQNofFjKFMVJyQKVzcC6caWcp8cuWrYAkJTPQAGzuN/Uhlhnq8fQMsn1Ftn7Ur+bi1td9lFd0z0Mla7Tvouo1rHJBIj5sa1UzBQZAqEExoeYZ+YRUOMK3w3zHKmoXKe4tawhATVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnVNSZa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnVNSZa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB30FC4CEC6;
	Tue, 15 Oct 2024 13:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997563;
	bh=Ug44KSDzfzhc1u5CWD3e9gYXrmDKoA/YvEPj8cSl86w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnVNSZa4c80CWBizFIOSkMRzRAKbT9drUY82/SUE/+qhzXCoEmyuv9LztD/ydmiXc
	 uig/pt0osFRhtXNTJTxuXAfGnghPshJ1fP5mLyNoMOlXRyETcSM84mflVtm9sDYGCj
	 RyBHZ4P+uFVW0mNhZAYNQ80bX+5/d7Wrmkl/Il9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 219/518] soc: versatile: integrator: fix OF node leak in probe() error path
Date: Tue, 15 Oct 2024 14:42:03 +0200
Message-ID: <20241015123925.449825320@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 874c5b601856adbfda10846b9770a6c66c41e229 upstream.

Driver is leaking OF node reference obtained from
of_find_matching_node().

Fixes: f956a785a282 ("soc: move SoC driver for the ARM Integrator")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/20240825-soc-dev-fixes-v1-1-ff4b35abed83@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/versatile/soc-integrator.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/soc/versatile/soc-integrator.c
+++ b/drivers/soc/versatile/soc-integrator.c
@@ -113,6 +113,7 @@ static int __init integrator_soc_init(vo
 		return -ENODEV;
 
 	syscon_regmap = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(syscon_regmap))
 		return PTR_ERR(syscon_regmap);
 


