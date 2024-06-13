Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B75143C50;
	Thu, 13 Jun 2024 12:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280730; cv=none; b=BnB5dcdHERXYi29mh2ci/7vscH7ND4K8o2e815n3HrkzzSN8hiHG0GFV88+Re3awNStMJ7gFjpKqh/W2tEw47bMR8TAJGdxq158k2wYweQHOpatrZ5cxzwGSjlfHtQ3c4EFfp0DqzvHN3PvxMVmTe8zpYum9NlZSldSzelUHnaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280730; c=relaxed/simple;
	bh=e/nuxvRQH3Dy8k3v7Cshp0yG8Ta1dFaSTD/Mj3deuWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tp4tOWOYTeetuETA3+m6tqnjCQm/Gk7NcexQPJoVSAf2uVJVnmUb8+DCNRu0UrycE73MJVfmpky/Pv5KInO6vJ6lN/TIYjE0uaPp+Naa3ES2IsXkXRL5NFcYxSvuXsa8AcXdcEH9zyHiyr+XlZEs87gS3qS6lwglUF8SLlMHvro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bErQfEKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bErQfEKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC3BC2BBFC;
	Thu, 13 Jun 2024 12:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280729;
	bh=e/nuxvRQH3Dy8k3v7Cshp0yG8Ta1dFaSTD/Mj3deuWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bErQfEKYrGMS0wY/IoKlFuIXRQLMu0ZLCznBYi/Q/4oL64wJt1ZIhJHWrNg4Wi+wZ
	 qAytpzTpg33M84597D//iTTBcyZDnrEaoRqII1Rm0Qmlo58qtYRa3eWb86VGGWjBmg
	 IPyBwHTkvmiyheIubbzY1n+Kx2itRmupq0kJ34k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/317] regulator: vqmmc-ipq4019: fix module autoloading
Date: Thu, 13 Jun 2024 13:30:33 +0200
Message-ID: <20240613113248.131333071@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 68adb581a39ae63a0ed082c47f01fbbe515efa0e ]

Add MODULE_DEVICE_TABLE(), so the module could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://msgid.link/r/20240410172615.255424-2-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/vqmmc-ipq4019-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/vqmmc-ipq4019-regulator.c b/drivers/regulator/vqmmc-ipq4019-regulator.c
index 6d5ae25d08d1e..e2a28788d8a22 100644
--- a/drivers/regulator/vqmmc-ipq4019-regulator.c
+++ b/drivers/regulator/vqmmc-ipq4019-regulator.c
@@ -86,6 +86,7 @@ static const struct of_device_id regulator_ipq4019_of_match[] = {
 	{ .compatible = "qcom,vqmmc-ipq4019-regulator", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, regulator_ipq4019_of_match);
 
 static struct platform_driver ipq4019_regulator_driver = {
 	.probe = ipq4019_regulator_probe,
-- 
2.43.0



