Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3CE11193;
	Mon,  4 Mar 2024 21:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588662; cv=none; b=o21hNn4m2c63ojQwuQT4Nxeh9FoN8OBDQZByZhOIEcIdUHGi7VrpeL9SmY5BfBSXeH0cuxNE8FBM9affKZzAPPmzddWaGmBJQro5cRa7BLbKGoP8IhUPt7/8ZTVYIGvlXm+/DmOHj0zb5kIJlkKWfIgVNId6trdyso1JggVzGuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588662; c=relaxed/simple;
	bh=QoYP5KymdQjpYfrNwAKh83hiJPGKjdt57vJhcgpUrDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXhy5GzoU099+TFd5hjD0A9UtyQW3fm3XMD5FDElZSsuPsCIlXkNLT6/C+ImYEgBsPr1bUE+DqsHug87afKBt9yQJSzKnHpJPW8uuBnW+HVOFN/mhxrrpNClQWuj5ilCEj/42HgxWGzPjlAyGCuKQSOcVCZB5TWVzY8eK7Ay/f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/R3hMhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/R3hMhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6AEC43390;
	Mon,  4 Mar 2024 21:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588662;
	bh=QoYP5KymdQjpYfrNwAKh83hiJPGKjdt57vJhcgpUrDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/R3hMhkCTouRx/ge5N/ZnAzLKA7KmcfAyv/2+pH8JN+EuVrwD2N1IHsauXqkEDys
	 Q9F4v5s8gM0YbFUtOmqcVW/qHxaaODLPfnhKmyWMTcrQgpfoYzLihVnTQMtweQqs1H
	 j8tFpl66JOMziLTEnAMg6m70biWwFG6tEuL5G+P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/215] Bluetooth: hci_qca: mark OF related data as maybe unused
Date: Mon,  4 Mar 2024 21:21:52 +0000
Message-ID: <20240304211558.551686036@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 7dcd3e014aa7 ("Bluetooth: hci_qca: Set BDA quirk bit if fwnode exists in DT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 76ceb8a0183d1..0e908a337e534 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1824,7 +1824,7 @@ static const struct hci_uart_proto qca_proto = {
 	.dequeue	= qca_dequeue,
 };
 
-static const struct qca_device_data qca_soc_data_wcn3990 = {
+static const struct qca_device_data qca_soc_data_wcn3990 __maybe_unused = {
 	.soc_type = QCA_WCN3990,
 	.vregs = (struct qca_vreg []) {
 		{ "vddio", 15000  },
@@ -1835,7 +1835,7 @@ static const struct qca_device_data qca_soc_data_wcn3990 = {
 	.num_vregs = 4,
 };
 
-static const struct qca_device_data qca_soc_data_wcn3991 = {
+static const struct qca_device_data qca_soc_data_wcn3991 __maybe_unused = {
 	.soc_type = QCA_WCN3991,
 	.vregs = (struct qca_vreg []) {
 		{ "vddio", 15000  },
@@ -1847,7 +1847,7 @@ static const struct qca_device_data qca_soc_data_wcn3991 = {
 	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
 };
 
-static const struct qca_device_data qca_soc_data_wcn3998 = {
+static const struct qca_device_data qca_soc_data_wcn3998 __maybe_unused = {
 	.soc_type = QCA_WCN3998,
 	.vregs = (struct qca_vreg []) {
 		{ "vddio", 10000  },
@@ -1858,13 +1858,13 @@ static const struct qca_device_data qca_soc_data_wcn3998 = {
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



