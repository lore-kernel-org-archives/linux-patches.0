Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1BD13C833;
	Tue, 14 May 2024 10:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683249; cv=none; b=DSNMEjTrqgw+M3IdawKxaxonfOKaafY6z+0ZkW06bfgwzxjgQSeUX1KSy/fAwDZq1bW9ysLfG/QOaga+iPrlJjLFKLd7zRentOu/L9VQRUEtEttKqLsdDIS2rboMG0sSrU2XJNqtwfMmTETHEGwauIMEFyFqygVmqWofvQI7B7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683249; c=relaxed/simple;
	bh=ibGXtxB8Tl0qDmribMMI/AedQmUCgQ0FZgPkRioWDN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a8wcjj9upnJ1kNYCvDhN05eJV8GUZKfVlYRp/0VRWcCG5pmShkyg/4H9ugU0mbBCL5F5OjaV+ihNdCrMf7pJx5xJ6XAA8S/Mwvo36C9+Z297KNntwb2E/uzeAzeBPrT0TqRdP7ZKjRD9lBhMbVkWa6eM1hYSyVn/QVNUY5hN9mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1eNN3Lv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1eNN3Lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32159C2BD10;
	Tue, 14 May 2024 10:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683249;
	bh=ibGXtxB8Tl0qDmribMMI/AedQmUCgQ0FZgPkRioWDN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1eNN3LvWKCR+R8PGMGavstuSK27535xFalrjPpL8EY0Jg3HCfe7OjSrRLy8q1mRz
	 UdU9iNTPcB+VvGciZa40mvtLTE844cSehGmIv9VPUSP26g8nsosS8aYaUA+60y8PjR
	 7jO+LM1w1/lEgg1rywDzbTnfVIHcYKb/xj81cSVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 190/336] platform/x86: ISST: Add Granite Rapids-D to HPM CPU list
Date: Tue, 14 May 2024 12:16:34 +0200
Message-ID: <20240514101045.774892553@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit d8c2d38c4d1dee8fe8e015b9ebf65bdd8e4da99b ]

Add Granite Rapids-D to hpm_cpu_ids, so that MSR 0x54 can be used.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20240415212853.2820470-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_if_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
index 08df9494603c5..30951f7131cd9 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_common.c
@@ -719,6 +719,7 @@ static struct miscdevice isst_if_char_driver = {
 };
 
 static const struct x86_cpu_id hpm_cpu_ids[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_D,	NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X,	NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X,	NULL),
 	{}
-- 
2.43.0



