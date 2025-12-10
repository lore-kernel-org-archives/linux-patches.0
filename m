Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF64302CC0;
	Wed, 10 Dec 2025 07:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352135; cv=none; b=XBERPoicIpbuDL2oH6DvvycBWnGL9kSnQLbRUxt4MvzKMUgeiMdBIu7w1GzioepnzKGBlWC24STCAYbF0WOn4biEBaNd4Oxiq3bYeBnihCYGR+yPmhYwwACDsLd5jwtbOrrGQMvfb3Z43wn12GxxGIlePQ1zxD9LheNT2KuQfc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352135; c=relaxed/simple;
	bh=casnYKAum16yEH39nX7746zwUGQxwwdOKN8iljmn/4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g6VhdSAykKaaMBMu7tTMLrw8d5VWXJ1wCnhar+U+zfnVWx9rrrVxgCsuCt7IxPFM6DujfO3znzVico9I+ahQnTlDEJjAONyVSX1ZuGYYx2Ey6BhMYQE4YttVK8gzq0hVyQIyYCFS9+6ngYOpfSCerjR1hXMbaVao/M+rlvwKbCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMhT4mR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMhT4mR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24979C4CEF1;
	Wed, 10 Dec 2025 07:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352135;
	bh=casnYKAum16yEH39nX7746zwUGQxwwdOKN8iljmn/4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMhT4mR+vuHy07SADg33ggVPJqLuDMhJS1ncgogEH5UQuEqVSAwl47yntOtRsqXzM
	 6gC5Y2LMlz9Td8uEf6hIkL0WjZeahyUzIwn5Bd4x0wvEcxnFsWRJ8OD9skGF5l3bKi
	 T7JH0UnKr8TAmLobvBKsEPusWYDIIpcGE5qhAktw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 45/60] platform/x86/intel/hid: Add Nova Lake support
Date: Wed, 10 Dec 2025 16:30:15 +0900
Message-ID: <20251210072948.984310073@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit ddf5ffff3a5fe95bed178f5554596b93c52afbc9 ]

Add ACPI ID for Nova Lake.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20251110235041.123685-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index f25a427cccdac..9c07a7faf18fe 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -55,6 +55,7 @@ static const struct acpi_device_id intel_hid_ids[] = {
 	{ "INTC10CB" },
 	{ "INTC10CC" },
 	{ "INTC10F1" },
+	{ "INTC10F2" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, intel_hid_ids);
-- 
2.51.0



