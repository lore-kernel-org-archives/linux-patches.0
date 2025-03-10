Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BC917A2E8;
	Mon, 10 Mar 2025 18:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629618; cv=none; b=DymSPkGwwkd6WbQR7BhNZBymbfWR1+DwPbuE6D6/tnycT343tgBUtglfVvWL3XGkm3YEqzijepyodD53GvigF4Zk2S7H9FvaYejrym4N3acY8SJnqSVtDiGgCqCe7KmoDijJFbc49zo4RG6dP6PQPInRt+efSvO+FHImjyOmxDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629618; c=relaxed/simple;
	bh=hjRlXyuNlQlqqoWWAVyPQ3ombHhTQ2e8xqJgtfYB3Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDeGFPSKhI5jd1YKA4dF9lZmv3zgYI1FOGpNUvwvfq48k3lJ/hhDg0pBhN9tEyOtnnrhyO8cQuPI+hRmJZsbi2Dovx9VSlhGepRnt0T3yD0iRojiEPPGOW36W7M2I2ne41wfwMSfkZFyGDU23FGmZsnz5oq3rTDjCXZWJsvsw10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwO472Im; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwO472Im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEBEC4CEE5;
	Mon, 10 Mar 2025 18:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629617;
	bh=hjRlXyuNlQlqqoWWAVyPQ3ombHhTQ2e8xqJgtfYB3Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwO472ImV3/NAv+4ot5FK04Rx6z2A7lrjTnL6xXA4oI3kgdnQ3TxVH6dq+N3MjmzP
	 00JkvMjPgE2egb4rMIP5WoNat61VCCClf7rCNkRt2JgeogsXnHc8YNBjs7QA17OObl
	 eRo9UPlfHtw2U5H1+GrIYVcsVFpd2r81D7by87/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.15 315/620] nvmem: qcom-spmi-sdam: Set size in struct nvmem_config
Date: Mon, 10 Mar 2025 18:02:41 +0100
Message-ID: <20250310170558.049930933@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

commit e88f516ea417c71bb3702603ac6af9e95338cfa6 upstream.

Let the nvmem core know what size the SDAM is, most notably this fixes
the size of /sys/bus/nvmem/devices/spmi_sdam*/nvmem being '0' and makes
user space work with that file.

  ~ # hexdump -C -s 64 /sys/bus/nvmem/devices/spmi_sdam2/nvmem
  00000040  02 01 00 00 04 00 00 00  00 00 00 00 00 00 00 00  |................|
  00000050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
  *
  00000080

Fixes: 40ce9798794f ("nvmem: add QTI SDAM driver")
Cc: stable@vger.kernel.org
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20241230141901.263976-6-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/qcom-spmi-sdam.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvmem/qcom-spmi-sdam.c
+++ b/drivers/nvmem/qcom-spmi-sdam.c
@@ -143,6 +143,7 @@ static int sdam_probe(struct platform_de
 	sdam->sdam_config.id = NVMEM_DEVID_AUTO;
 	sdam->sdam_config.owner = THIS_MODULE;
 	sdam->sdam_config.stride = 1;
+	sdam->sdam_config.size = sdam->size;
 	sdam->sdam_config.word_size = 1;
 	sdam->sdam_config.reg_read = sdam_read;
 	sdam->sdam_config.reg_write = sdam_write;


