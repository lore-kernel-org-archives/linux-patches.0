Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1092A13776F;
	Wed,  3 Jul 2024 11:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005437; cv=none; b=lXiPJHsrrCVfXHyF2DWAF+HlvlsXoP7qM6pc0uE6vjk0FKRGrEUW1ATUEiIgUmcOPO1Ipx9lQaVVhca9IqexwBr9n0Q6y1siXUDTzHDSjhUW9J37ezQkxbLnZonhe7/jpTvIskIph0d+yNudJstatRZ5n7fAxtCJOen6h99ffUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005437; c=relaxed/simple;
	bh=OAMtVtJErTMt1EyansBONgEoiekQmYnsqBk7qgF1AMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tdTuFvLQwxPkscYIQM0kgTdRF3FYilnrEGQYi/LITDPW83AVAcwRt/BTatsb0rECApbzukW2raLKcSvXoYuWA2q4mnYhxv/8MFqxsuKxeZqB3mKjMTCXQ8ZDLl3DkPWLcWmOat+6j3pECn3yHSdKjX3FVXWJF15vnGRQAZIafUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nl9Wy9sI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nl9Wy9sI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CA9C2BD10;
	Wed,  3 Jul 2024 11:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005436;
	bh=OAMtVtJErTMt1EyansBONgEoiekQmYnsqBk7qgF1AMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nl9Wy9sIKejYrvHK1YUFHD5vUWtlJHwyKIISyuGzyhUr5NG43LwbOxs8ARs7Z2sXS
	 tsrImmrvInzCBErExejxiMlLKCl4WN3qOVlh6aUgG07rmdYAKIGUF8c1wu1VSvcxI8
	 DIvDK3XtitRWt85gieGkUyGUX/ZhLU6PWmp03vCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/356] Bluetooth: hci_qca: mark OF related data as maybe unused
Date: Wed,  3 Jul 2024 12:36:25 +0200
Message-ID: <20240703102914.949842702@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 44fac8a2fd2f72ee98ee41e6bc9ecc7765b5d3cc ]

The driver can be compile tested with !CONFIG_OF making certain data
unused:

  drivers/bluetooth/hci_qca.c:1869:37: error: ‘qca_soc_data_wcn6750’
  defined but not used [-Werror=unused-const-variable=]
  drivers/bluetooth/hci_qca.c:1853:37: error: ‘qca_soc_data_wcn3998’
  defined but not used [-Werror=unused-const-variable=]
  drivers/bluetooth/hci_qca.c:1841:37: error: ‘qca_soc_data_wcn3991’
  defined but not used [-Werror=unused-const-variable=]
  drivers/bluetooth/hci_qca.c:1830:37: error: ‘qca_soc_data_wcn3990’
  defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: cda0d6a198e2 ("Bluetooth: qca: fix info leak when fetching fw build id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index fb71caa31daa7..1c2bd292ecb7c 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1834,7 +1834,7 @@ static const struct hci_uart_proto qca_proto = {
 	.dequeue	= qca_dequeue,
 };
 
-static const struct qca_device_data qca_soc_data_wcn3990 = {
+static const struct qca_device_data qca_soc_data_wcn3990 __maybe_unused = {
 	.soc_type = QCA_WCN3990,
 	.vregs = (struct qca_vreg []) {
 		{ "vddio", 15000  },
@@ -1845,7 +1845,7 @@ static const struct qca_device_data qca_soc_data_wcn3990 = {
 	.num_vregs = 4,
 };
 
-static const struct qca_device_data qca_soc_data_wcn3991 = {
+static const struct qca_device_data qca_soc_data_wcn3991 __maybe_unused = {
 	.soc_type = QCA_WCN3991,
 	.vregs = (struct qca_vreg []) {
 		{ "vddio", 15000  },
@@ -1857,7 +1857,7 @@ static const struct qca_device_data qca_soc_data_wcn3991 = {
 	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
-static const struct qca_device_data qca_soc_data_wcn3998 = {
+static const struct qca_device_data qca_soc_data_wcn3998 __maybe_unused = {
 	.soc_type = QCA_WCN3998,
 	.vregs = (struct qca_vreg []) {
 		{ "vddio", 10000  },
@@ -1868,13 +1868,13 @@ static const struct qca_device_data qca_soc_data_wcn3998 = {
 	.num_vregs = 4,
 };
 
-static const struct qca_device_data qca_soc_data_qca6390 = {
+static const struct qca_device_data qca_soc_data_qca6390 __maybe_unused = {
 	.soc_type = QCA_QCA6390,
 	.num_vregs = 0,
 	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
-static const struct qca_device_data qca_soc_data_wcn6750 = {
+static const struct qca_device_data qca_soc_data_wcn6750 __maybe_unused = {
 	.soc_type = QCA_WCN6750,
 	.vregs = (struct qca_vreg []) {
 		{ "vddio", 5000 },
-- 
2.43.0



