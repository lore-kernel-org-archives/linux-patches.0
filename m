Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7579E168C4;
	Mon, 27 May 2024 19:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837605; cv=none; b=TAMfOLUpUpF7CoGxM+sLPW8dOYcoiwhmKhh/6YbhHfuTYGuSJr0Hf80eQMw3v7Zf9YtTa5dY7n6sSaPbAj+s48Kr7VdyjWP1HBnAcW7JH00UlrkRBAlB9qJ/4ILvChDo/vL9R7unoxbY+7XL7eaCX8HOIiRQae2CbanYGBFBYhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837605; c=relaxed/simple;
	bh=lk7O5ELhVNqDg4kjcH2Oyz84qDHFqd0y1BLYXQeDcGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnR40YmMLKCpHltnFFD6DUzLMO4nwCSag8WXAzF5JBh+1j/7CF6C9oBXtQhjA5uwehIGGjVKYtMHrC5JlntAL0lk4OkFkZxEfhCmihksULHI/EFXdN66GYdXFzINJGg25VrztdbjyWbzkB0diMoZAhUsDmhnSxiVTCjwhXrlyOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QO5u83sK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QO5u83sK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A49EC2BBFC;
	Mon, 27 May 2024 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837605;
	bh=lk7O5ELhVNqDg4kjcH2Oyz84qDHFqd0y1BLYXQeDcGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QO5u83sKAjMwzyrHfb7DU8x7TlC0KsTolgNSXil1/Ap7wWnDK4JA8zCmbkPgQTzF5
	 8yPy14VEUGElv6IckPUdRo/709JxvrnOPuWdJ4YKAlxC57dM2yMjhyK1O+8NidD6Ae
	 UE6bq3xS3unX4EX23RRkK887o56DW5nnN+WBUakQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 074/493] regulator: qcom-refgen: fix module autoloading
Date: Mon, 27 May 2024 20:51:16 +0200
Message-ID: <20240527185632.362108416@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit ddd3f34c10002e41ed3cd89c9bd8f1d05a22506a ]

Add MODULE_DEVICE_TABLE(), so the module could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://msgid.link/r/20240410172615.255424-1-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-refgen-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/qcom-refgen-regulator.c b/drivers/regulator/qcom-refgen-regulator.c
index 656fe330d38f0..063e12c08e75f 100644
--- a/drivers/regulator/qcom-refgen-regulator.c
+++ b/drivers/regulator/qcom-refgen-regulator.c
@@ -140,6 +140,7 @@ static const struct of_device_id qcom_refgen_match_table[] = {
 	{ .compatible = "qcom,sm8250-refgen-regulator", .data = &sm8250_refgen_desc },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, qcom_refgen_match_table);
 
 static struct platform_driver qcom_refgen_driver = {
 	.probe = qcom_refgen_probe,
-- 
2.43.0



