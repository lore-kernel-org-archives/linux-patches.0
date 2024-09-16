Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A642149C57;
	Mon, 16 Sep 2024 12:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488715; cv=none; b=UnomQsbBVW+b3FJGh6rwrwP7Ix5ld2+N5walNP6xxFzbYyKN3JKIBVO/7tVT2igwFzeFWHiy7mjp6rKJLdiXqZAqKrDYK7MjbchZiw+QfIT5p/9+CII3prEh9mFPfTKkNnVTin+JolDGxhkkpK2mZXhMFpym5g6nLv1CeN6p7Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488715; c=relaxed/simple;
	bh=uQK7XXz+c8jr/UbMvruxZ/bXdQoPkeSh9m9Iv00EXGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Avfh2itzUHqbc4VzE0HSCSnUSW46yaAk8XyPVueQm1V4FFg24318xeymFU6c6adcNlX7i6X12bAB+N17B76kpJN6DOJdMdsDKQ9cUoYPYcA/jRwGNIk8R8WkVSOh/4+iRvbwjKoxVwLuWumv9leGibBaO3XfwSk7W2B0x7AeyhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZqorgZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZqorgZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053B6C4CEC4;
	Mon, 16 Sep 2024 12:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488715;
	bh=uQK7XXz+c8jr/UbMvruxZ/bXdQoPkeSh9m9Iv00EXGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZqorgZ3ki5sAjC3UPzHA+LHoEGmBPMlzJkbJRTq3mfMiVkqduzotxG2ROGo1VUeC
	 PDGHVLoXBBynUsxkF6VXkkvciLPMt4WKBjXPdjKiu09voq1jvaQanmamNYmGmTV/XR
	 Cnmr3WAbetFIXdF1w2ejOwDPhQlb7UYI3P0MbKAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 89/91] pinctrl: meteorlake: Add Arrow Lake-H/U ACPI ID
Date: Mon, 16 Sep 2024 13:45:05 +0200
Message-ID: <20240916114227.383162976@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit a366e46da10d7bfa1a52c3bd31f342a3d0e8e7fe upstream.

Intel Arrow Lake-H/U has the same GPIO hardware than Meteor Lake-P but
the ACPI ID is different. Add this new ACPI ID to the list of supported
devices.

Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/intel/pinctrl-meteorlake.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pinctrl/intel/pinctrl-meteorlake.c
+++ b/drivers/pinctrl/intel/pinctrl-meteorlake.c
@@ -583,6 +583,7 @@ static const struct intel_pinctrl_soc_da
 };
 
 static const struct acpi_device_id mtl_pinctrl_acpi_match[] = {
+	{ "INTC105E", (kernel_ulong_t)&mtlp_soc_data },
 	{ "INTC1083", (kernel_ulong_t)&mtlp_soc_data },
 	{ "INTC1082", (kernel_ulong_t)&mtls_soc_data },
 	{ }


