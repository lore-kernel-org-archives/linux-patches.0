Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1921720F98
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90177C433C7;
	Fri, 21 Jul 2023 19:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966829;
	bh=xJtnsLagXBick59RQTp7gYVHQmcOHr2GmEyZKpcrdmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0iQMAXhNLshmLyMCqtLMlkGjom9jL7tw81eHR13ZC7BUWBwiJX7sMr1i3lIdrjJy
	 V0Lw2oqnKq5aM0u2JdPPktrKmu993BoqiJlcZAf+iwoPZW0PsZkyTUl78OU1l95rEe
	 ksTdzGB+ZajcmRvVCUl9zDEPvroXOtrcovRKwshg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 483/532] mfd: pm8008: Fix module autoloading
Date: Fri, 21 Jul 2023 18:06:27 +0200
Message-ID: <20230721160640.680524881@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit d420c9886f5369697047b880221789bf0054e438 upstream.

Add the missing module device table alias to that the driver can be
autoloaded when built as a module.

Cc: stable@vger.kernel.org      # 5.14
Fixes: 6b149f3310a4 ("mfd: pm8008: Add driver for QCOM PM8008 PMIC")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230526091646.17318-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/qcom-pm8008.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mfd/qcom-pm8008.c
+++ b/drivers/mfd/qcom-pm8008.c
@@ -233,6 +233,7 @@ static const struct of_device_id pm8008_
 	{ .compatible = "qcom,pm8008", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, pm8008_match);
 
 static struct i2c_driver pm8008_mfd_driver = {
 	.driver = {


