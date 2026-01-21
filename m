Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499AF3A8FFC;
	Wed, 21 Jan 2026 18:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019995; cv=none; b=ld20DAMbnXTp3liTYmTfWHvmJRLyYfCIa3lnAaUvl+N+5IxU+co6cUCDQQRfojY5r/FWtBz5fNmhyOiKNHyLV2bRPWWaiPz3vecHmV5Xs2LijGcJhwNQaV0ZwwsUp54CDAfiqkU66qz5Km6Ru2Qv+Ia5VDWCHJB1vusgW+KWZz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019995; c=relaxed/simple;
	bh=wfWco/C26WTYcbrxrBKysn7h4zIvD3V8eeEyF/oIsdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ix/bJex8cWc8zkC+iF+weUlMaCkVRP5AAxL6wjQn7IErXdPINYlsGzlRT+S4SNISBFt0ImKh6OkGVWGGwtliFwVGtwbROg+gmeCzkDfac2yrJ/yHmbck+9cl/b7t/fuqVgEor7Uj8TojSYBuJmPm4EJqtSigIjAARH4kkzffcT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjzWq96G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjzWq96G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0C9C4CEF1;
	Wed, 21 Jan 2026 18:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019994;
	bh=wfWco/C26WTYcbrxrBKysn7h4zIvD3V8eeEyF/oIsdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjzWq96GryRvgFSXefSHLbp5Hb1A4GJ6Vc/I4zlodxhz4ufFnEJ/O4URAnuGwr1QN
	 Sy4jHFI0k+LdxI6wiceJ7xIOOQSTgv1vz9PSOqAK7oCCj7hSqk/NUYAEtse88wbVrI
	 W+C77UFf31TLH7Ml7UC0j6KP91mRvHWjKM9yxSuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Christoph Hellwig <hch@lst.de>,
	Janne Grunau <j@jannau.net>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 003/198] nvme-apple: add "apple,t8103-nvme-ans2" as compatible
Date: Wed, 21 Jan 2026 19:13:51 +0100
Message-ID: <20260121181418.665977138@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

commit 7d3fa7e954934fbda0a017ac1c305b7b10ecceef upstream.

After discussion with the devicetree maintainers we agreed to not extend
lists with the generic compatible "apple,nvme-ans2" anymore [1]. Add
"apple,t8103-nvme-ans2" as fallback compatible as it is the SoC the
driver and bindings were written for.

[1]: https://lore.kernel.org/asahi/12ab93b7-1fc2-4ce0-926e-c8141cfe81bf@kernel.org/

Cc: stable@vger.kernel.org # v6.18+
Fixes: 5bd2927aceba ("nvme-apple: Add initial Apple SoC NVMe driver")
Reviewed-by: Neal Gompa <neal@gompa.dev>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Janne Grunau <j@jannau.net>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/apple.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1703,6 +1703,7 @@ static const struct apple_nvme_hw apple_
 
 static const struct of_device_id apple_nvme_of_match[] = {
 	{ .compatible = "apple,t8015-nvme-ans2", .data = &apple_nvme_t8015_hw },
+	{ .compatible = "apple,t8103-nvme-ans2", .data = &apple_nvme_t8103_hw },
 	{ .compatible = "apple,nvme-ans2", .data = &apple_nvme_t8103_hw },
 	{},
 };


