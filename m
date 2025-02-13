Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1A214A605;
	Thu, 13 Feb 2025 15:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460815; cv=none; b=MjDQEYBKpVosbcXrYhU49hq25bULbFuqlG92OIJywFQMHKyyKg3eRKf+9de9jR0Ui8PG/GLKl8frPXSRVxSGtLdOj72ce88VSxD6zVShgHxW/KrWus6FZOri2etzBAzMhwiWoETNs72NnnbIZceCU5UwVzVA+H0B0UzoqAQD3NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460815; c=relaxed/simple;
	bh=OvkX8KFeO4ijvF/eNHkMNXh4TAEl9QkLQT/NsLqssD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOQjX0vc0hwt8fZu9MNwm7qEimLwF/2ELdF0EoIPq0tNSlr3MVDq7QGPhXDXsD0nnVjCpr7gTxWkD+xpU4umO7/XEbaP2W5i9DCb0aqCo+GOdYsv3GjSjEKR7KtqgzNfVeWsQzxDQiDYPXJieudr4LoQQ2g5/KM9oosmpgUU1es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ny6F37Gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ny6F37Gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9477FC4CED1;
	Thu, 13 Feb 2025 15:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460815;
	bh=OvkX8KFeO4ijvF/eNHkMNXh4TAEl9QkLQT/NsLqssD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ny6F37GukB5wvmOgSLVkM4qvEYY+2/782Nr7L4mO8sR7BDlFjjvwt8/YoUdx8TvTP
	 Zut/gidivMn6rCjZtPriFZdyEZ1wK7n886JJ6WVSKWCJH+3vp8wDouWWAD2HeBdx6+
	 pAo976oRYOIo1eMX+HIT9z9jnTXEecW+kNUQqw6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 221/273] nvmem: qcom-spmi-sdam: Set size in struct nvmem_config
Date: Thu, 13 Feb 2025 15:29:53 +0100
Message-ID: <20250213142416.045747804@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -144,6 +144,7 @@ static int sdam_probe(struct platform_de
 	sdam->sdam_config.owner = THIS_MODULE;
 	sdam->sdam_config.add_legacy_fixed_of_cells = true;
 	sdam->sdam_config.stride = 1;
+	sdam->sdam_config.size = sdam->size;
 	sdam->sdam_config.word_size = 1;
 	sdam->sdam_config.reg_read = sdam_read;
 	sdam->sdam_config.reg_write = sdam_write;


