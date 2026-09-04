Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A0C7080D;
	Fri,  4 Sep 2026 05:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501479; cv=none; b=aBCRkm8AlVX+Tn1VfgrYK9O0M7x57eldTPdQph72H5anV8YN5k/SeSvC7ZwRSwR42yY550Oldqe3xbVEXr7kUrLaF3PgDG5fP3oKTijRo32XdexOjGOLS/y+B+mtbFtTX6mnw7KMd+5lU4SUUCyIj74RN5JsgF1sLhCGzW4t79U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501479; c=relaxed/simple;
	bh=OHJ06QTgRImzpoCGpce06Pq67yPzLYNYMB637HL3Pes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UgKkBU+zD0DX+DqjsvHkoEWzwT5MnTovAUqTl0/T+TiC5CvxKGCC1EJ+EuHqXXNmYlIh9K+12/7/PYO32csaP4b4tEn1KWjs4K6blOF7QB8lkpzZq7N7KN1m6vuxZmDGt8GTvl5oJC6xdZ4gj+6mPS7M3wgsrAVyoAmUnoX57VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtPjQ5ab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtPjQ5ab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4DE1F00A3D;
	Fri,  4 Sep 2026 05:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501478;
	bh=FVyvLi8rCby4mMJ12yx3UC+V/Id7x+mtne7Dy8SeqJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GtPjQ5absqGyrqYhgkHGcby9Hyh5CUDXouDv6eQlE/AgK8j6TvvL+/uE2APJcY1F/
	 n1V1HwK/G9iM0JW0RTJ4nD7zukFhkIyea5lsrQrqwi4ViLF0FKmtSkD40H5PNqWerZ
	 CzE8VYDYWwwVamu/HF9ZhH/lsqR9xLDY/IKk3b5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 423/552] platform/x86: ISST: Validate parameter for frequency and priority
Date: Fri,  4 Sep 2026 06:59:40 +0200
Message-ID: <20260904045800.194328951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 574b59bb4b6bfcfd1f639d02f1041b314d43a2e6 upstream.

Validate range for frequency and proportional priority while setting
CLOS parameters.

Fixes: 12a7d2cb811d ("platform/x86: ISST: Add SST-CP support via TPMI")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260811221514.3905817-5-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -661,6 +661,9 @@ static long isst_if_core_power_state(voi
 
 #define SST_MAX_CLOS			3
 
+#define SST_MAX_FREQ			0xff
+#define SST_CLOS_MAX_PRIORITY		0x0f
+
 static long isst_if_clos_param(void __user *argp)
 {
 	struct tpmi_per_power_domain_info *power_domain_info;
@@ -680,6 +683,15 @@ static long isst_if_clos_param(void __us
 		if (power_domain_info->write_blocked)
 			return -EPERM;
 
+		if (!in_range(clos_param.min_freq_mhz / SST_MUL_FACTOR_FREQ, 0, SST_MAX_FREQ + 1))
+			return -EINVAL;
+
+		if (!in_range(clos_param.max_freq_mhz / SST_MUL_FACTOR_FREQ, 0, SST_MAX_FREQ + 1))
+			return -EINVAL;
+
+		if (!in_range(clos_param.prop_prio, 0, SST_CLOS_MAX_PRIORITY + 1))
+			return -EINVAL;
+
 		_write_cp_info("clos.min_freq", clos_param.min_freq_mhz,
 			       (SST_CLOS_CONFIG_0_OFFSET + clos_param.clos * SST_REG_SIZE),
 			       SST_CLOS_CONFIG_MIN_START, SST_CLOS_CONFIG_MIN_WIDTH,


