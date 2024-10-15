Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4461C07C2;
	Tue, 15 Oct 2024 12:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997033; cv=none; b=ZRXf2z3PS14No/Cb0dyKCuG06KJ7PN119Twd0A4I5bXGm7Ad4dAjXthFEcJDovl0XaxeVwyWMmQ3EplsOuek8KRR1OkDQ2kmOtTTX/W0vyTukAFRQFWwmrKFjjSaQ3LzEyG458wcz8EJirvy/thVZfJUNp5deI2lM5TuQqG0IbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997033; c=relaxed/simple;
	bh=dK0vNMw+LiWhgqPZNoJ8Bo376B6wjern/RvbrRfHWwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0EJRTCJVSOgxPH3VzN9H8qCzWmdoCFJFOq8dikatl1WQwN/RozK8hiC/k8SH2nswvPridbuRUF+9HtxKAQ9J/B5eCjvx9Nqxed78IqCQ3PDRxxdWVO8v9Qb0qKTgECL5kaDp3WD9IlaVYbCUE46Jyr25tOVxV9WdWJjL0rZQvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxndxU56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxndxU56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4496FC4CEC6;
	Tue, 15 Oct 2024 12:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997033;
	bh=dK0vNMw+LiWhgqPZNoJ8Bo376B6wjern/RvbrRfHWwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxndxU56KjRI0VUaiAvUhhq0XknOfWjEmULCoOaM+XKD3KRfzFNDm7LM1K3B8+3qJ
	 OT003N+ReqG2Q4P90NRU6AdfxQi5w+i1tLR0MXvPUx6loa8ILpNDlvk9/SxteqxrJD
	 G9ksDiHmeqVK7zHMGD06mIhqHJU7Ed7PxWKd0asY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/518] ASoC: intel: fix module autoloading
Date: Tue, 15 Oct 2024 14:39:01 +0200
Message-ID: <20241015123918.435312244@linuxfoundation.org>
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

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit ae61a3391088d29aa8605c9f2db84295ab993a49 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Link: https://patch.msgid.link/20240826084924.368387-2-liaochen4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/keembay/kmb_platform.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/keembay/kmb_platform.c b/sound/soc/intel/keembay/kmb_platform.c
index 291a686568c26..c7b754034d24f 100644
--- a/sound/soc/intel/keembay/kmb_platform.c
+++ b/sound/soc/intel/keembay/kmb_platform.c
@@ -634,6 +634,7 @@ static const struct of_device_id kmb_plat_of_match[] = {
 	{ .compatible = "intel,keembay-tdm", .data = &intel_kmb_tdm_dai},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_plat_of_match);
 
 static int kmb_plat_dai_probe(struct platform_device *pdev)
 {
-- 
2.43.0



