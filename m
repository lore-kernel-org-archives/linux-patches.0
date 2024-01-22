Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037845FDAB;
	Tue, 23 Jan 2024 00:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969774; cv=none; b=AhxPaOQKRCGg/e7VonxRo+C+HxOMdj/UYBrso5LPd9BkZxmpvhbCer4RtxOP4IjGcA2luR10YMiqRfhkPQO7/NhooxHecM2Za37b/JbfwkBS3IMgNnVQ0WFBj9Kr07YwhFPriYqZUpSN2TSBvIdHRuLTIufWDYfRKp+hoHG9pWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969774; c=relaxed/simple;
	bh=DAIQeojWJFn/gU7IZkIQhZSIB2BC+NcKw1aT1mM4b4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ofn7/vgWzO9zoeWsaX3nEUvQBckiSSQph9fKZ8gp03tn4J/OU6CvSBEEt6XZzixfrlzbm7awiWrZxb49lBIc/YjPR8tH7Ey67ACf+uvpbjfn5/usgOOgk6o96nv1sEcVtD33t5l4yxM5CEx36Q3946ceItH/FRYko+0XIwTM/0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+/nsQ/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+/nsQ/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06B9C433F1;
	Tue, 23 Jan 2024 00:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969773;
	bh=DAIQeojWJFn/gU7IZkIQhZSIB2BC+NcKw1aT1mM4b4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+/nsQ/dvKY35niQL50wHKhpfRaUCksCOZXS1mpwGjZrZLmWTapsazuc+PgDL9fqu
	 yHxvzJP5KaFvZI8LTTqQ1T/326tklqjoNHnQVnh9IAOLyvz5QWHLwsMFELciXuLllW
	 1+C/7JcnGQpyyCxic8YQ8YSg0bi0Z21Db0CAPHRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 440/641] drm/amd: Enable PCIe PME from D3
Date: Mon, 22 Jan 2024 15:55:44 -0800
Message-ID: <20240122235831.784271104@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit bd1f6a31e7762ebc99b97f3eda5e5ea3708fa792 upstream.

When dGPU is put into BOCO it may be in D3cold but still able send
PME on display hotplug event. For this to work it must be enabled
as wake source from D3.

When runpm is enabled use pci_wake_from_d3() to mark wakeup as
enabled by default.

Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2265,6 +2265,8 @@ retry_init:
 
 		pci_wake_from_d3(pdev, TRUE);
 
+		pci_wake_from_d3(pdev, TRUE);
+
 		/*
 		 * For runpm implemented via BACO, PMFW will handle the
 		 * timing for BACO in and out:


