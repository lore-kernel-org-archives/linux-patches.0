Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8D9330B00;
	Fri, 17 Oct 2025 15:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715765; cv=none; b=CHtjHisKytX5SIdI2C69JNYA5dklelAT/eDAu4kgZIHKJs265AbEvcFx50eWJLR1JeTgR71fuxISaU+4QzsQz73uMvIr+I16lfRMsHxykd2V9D6uRK4wR3JVb621HGbRZhsYGgcZTtcX9iRJJdqTSdilXiMp/A01J9HmxpdqMXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715765; c=relaxed/simple;
	bh=JoXJKfOU5DEx40hFnpI9EFo5VisVevz3l/ClKtvr1SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCATaM70QjO99aKHjug1p8tpquJChpZQI4TpUXuCsdVkHZ7Gknz8zd/E01k5Kn2+9C4fG1AHPVZbez5YYQOkVow4HbTNVs/b1p+x7UztXhQbcU1h5hdPVdG+2FOGTNBbgv+rXdkJt6stUmUSjqfaD2Xw25VHebt8Q+uaffCxwpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXiitud6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXiitud6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB9EC4CEE7;
	Fri, 17 Oct 2025 15:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715765;
	bh=JoXJKfOU5DEx40hFnpI9EFo5VisVevz3l/ClKtvr1SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXiitud624r/hc7VowHfXiTJE/jHy6w9e8oP9fsvZcvo/oehLAtSeQU1OqQ+dvSCX
	 oHwHGnqTd2cI5aY+u9wbPuclhw7we7h2RTzTDeTgXZUzxTJ863PcqHQw9WGnmb4HqF
	 l72Ww8EP6eqStvFaHribpDSKpfAi2s9dnESdChJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.17 329/371] media: iris: Fix buffer count reporting in internal buffer check
Date: Fri, 17 Oct 2025 16:55:04 +0200
Message-ID: <20251017145213.980717661@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit cba6aed4223e83ae0f2ed1c0f68d974fd62847bc upstream.

Initialize the count variable to zero before counting unreleased
internal buffers in iris_check_num_queued_internal_buffers().
This prevents stale values from previous iterations and ensures accurate
error reporting for each buffer type. Without this initialization, the
count could accumulate across types, leading to incorrect log messages.

Fixes: d2abb1ff5a3c ("media: iris: Verify internal buffer release on close")
Cc: stable@vger.kernel.org
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # X1E80100
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # x1e80100-crd
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_vidc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/qcom/iris/iris_vidc.c
+++ b/drivers/media/platform/qcom/iris/iris_vidc.c
@@ -240,6 +240,7 @@ static void iris_check_num_queued_intern
 
 	for (i = 0; i < internal_buffer_count; i++) {
 		buffers = &inst->buffers[internal_buf_type[i]];
+		count = 0;
 		list_for_each_entry_safe(buf, next, &buffers->list, list)
 			count++;
 		if (count)


