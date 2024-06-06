Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299CC1A0DD5;
	Thu,  6 Jun 2024 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683168; cv=none; b=qng8jU7PLTqPJ1bNHIkthene5iT4yMKwiH7OwdkMCMS7KeNSkobmAnxpsu3O2ftrXVAEbjj00ZZKfGO6fHG9zOxUCDbsbGfyAVvZ6M25wGxUoDPh+/TJUHvT0LN/YuWx6klIYW/CLe/PE9wmQ+94VYY9YAW/OJ8CIyVWWIQ6AEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683168; c=relaxed/simple;
	bh=9eyLTadEgD+6lTTUUNA1iztUhQ47kJmBRhgARzKJI6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GA1cxVm5VMlXuF2+AKBEbqILouGfSURoFzgNSS2Jk3EkybahcOWiiDbEsCsO9MhSRP8dyRs4druN0crC2zDb5FffSTm9xIrhJGIvl/GcKqvWfSw3V2/ZrpFcrxC3we7a1DuS3qGACFf5TGGBW/cL+JQC6Rl3WHSz/F4uyFbTdHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqNegmHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqNegmHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B20C2BD10;
	Thu,  6 Jun 2024 14:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683168;
	bh=9eyLTadEgD+6lTTUUNA1iztUhQ47kJmBRhgARzKJI6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqNegmHy1R6aXllkvUGSiC1EtpEuiSYSqgFeqGt/E4cjvNklY82EFAiaUem19jBwD
	 xHC/NjJihVgGnI+X+R1MhlkSrVJKfUAJ6YggBXP9HusWp+I9/wcyq4JXhBmQO2NTqR
	 xP/s2mPtE60kZ42owYI3AIuAlxfzyXmjJ5sN1EjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/473] regulator: vqmmc-ipq4019: fix module autoloading
Date: Thu,  6 Jun 2024 15:59:32 +0200
Message-ID: <20240606131701.310566105@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c4213f096fe57..4f470b2d66c97 100644
--- a/drivers/regulator/vqmmc-ipq4019-regulator.c
+++ b/drivers/regulator/vqmmc-ipq4019-regulator.c
@@ -84,6 +84,7 @@ static const struct of_device_id regulator_ipq4019_of_match[] = {
 	{ .compatible = "qcom,vqmmc-ipq4019-regulator", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, regulator_ipq4019_of_match);
 
 static struct platform_driver ipq4019_regulator_driver = {
 	.probe = ipq4019_regulator_probe,
-- 
2.43.0



