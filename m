Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3465F1487CD;
	Thu, 12 Dec 2024 15:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016612; cv=none; b=j/ATGKncAEI/arQ0E++T7mE3i/y+BpSmybCZLt6zY3JZqqmd/INknNI+DXMkG/C7TI5TJSgxokXETfOS4h6kjQ7ATOJm3FL4KLrI+zN5Ns+TwAks3KM4Izc++07GL6zcEEds7nW7Rd7qf/pfe0ErXhwQvQ2u+sVHrrwugGEgadU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016612; c=relaxed/simple;
	bh=9+f0+uSxH9DMD65IK4pEnFeWgHzpDo+LBpzHTwc5Wg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zpe0NdZbrC3Ri+HL0ZmGa7zJuHjpZFZFZyeK4wY6VL+APNfeCHL3CphndxUjFZN4oXmigUcU3HpMGehhA6FHeOSRBFX3K0iifkVifyogWLudxZRdPA1sLy2NHX7Y+ofm2n18b83vczqz/2I7pGWvZpgIbCGKT8ipG/pzZnqQ/ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Smn8KT2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Smn8KT2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9582BC4CED7;
	Thu, 12 Dec 2024 15:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016612;
	bh=9+f0+uSxH9DMD65IK4pEnFeWgHzpDo+LBpzHTwc5Wg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Smn8KT2bWOL44nwKbvBtL6ZfY83sBCSz+BOKHdl8+bt8hvttxLtPXm84KbSvJIu7y
	 q+3EgEcF+HQ06I2DQBJ8Zj0L60vwLfh7oltPIDhqPkGVgB5jmFhC6dBXMBf4o62pJr
	 t4b4/wwKbgYp/B78q3tZ0wwCmma9O/yKfZZH9RaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stefan Schmidt <stefan.schmidt@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/466] firmware: qcom: scm: Allow QSEECOM on Dell XPS 13 9345
Date: Thu, 12 Dec 2024 15:56:56 +0100
Message-ID: <20241212144316.547058012@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>

[ Upstream commit 304c250ba121f5c505be3fc13dec984016f3c032 ]

Allow particular machine accessing eg. efivars.

Signed-off-by: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Stefan Schmidt <stefan.schmidt@linaro.org>
Link: https://lore.kernel.org/r/20241003211139.9296-3-alex.vinarskis@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index f019e0b787cb7..14afd68664a91 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1742,6 +1742,7 @@ EXPORT_SYMBOL_GPL(qcom_scm_qseecom_app_send);
  + any potential issues with this, only allow validated machines for now.
  */
 static const struct of_device_id qcom_scm_qseecom_allowlist[] __maybe_unused = {
+	{ .compatible = "dell,xps13-9345" },
 	{ .compatible = "lenovo,flex-5g" },
 	{ .compatible = "lenovo,thinkpad-t14s" },
 	{ .compatible = "lenovo,thinkpad-x13s", },
-- 
2.43.0



