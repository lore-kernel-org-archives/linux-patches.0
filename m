Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F89126A0C1;
	Tue,  8 Apr 2025 10:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109980; cv=none; b=ZhSnnDCU5mxjUQXdvHPQ3EcU3l0+8O5yDiMC8+UkkDnrCe9n5Jt0to365FG1zcOCOQAtJdioFxpPtkNALBzVc4VgzfdjumEe5tohmYhOHxToerZi8gfA19k3KtWruUbE4WtrTJ1NGZZdWMiDFLh7dPz7CqjwfF4l6mTNfZCPsFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109980; c=relaxed/simple;
	bh=D2dLK5E3z7gwUUFOnnN55L/gahHk8MDFI0Y+t5t0BpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZGWZTCc0xbRHz+8zkxmgFWSTjaytSroUIIDM1DkOvonX8pz5egHND95Dc6jLUchTyeTndfSc014Hye4Y57G6oRXkJabsLSqpal9rPAmbfzaWbyUbiSQV7owdj5YQhRghPHIe+JqDT/+Ob6QZ/5BUsLV9gVeqaVEphVqdUeB6XLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBVTMA0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBVTMA0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BC9C4CEE5;
	Tue,  8 Apr 2025 10:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109980;
	bh=D2dLK5E3z7gwUUFOnnN55L/gahHk8MDFI0Y+t5t0BpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBVTMA0AMQgDH5aA1+L3FSQrz730iS4Jrg0hGb8tw8G7FXTy8ogXgKPxrAXIUfHxM
	 lQyqcLmWxw0RF/bDydKnF/Ns3IWxy0NRlCTBr7rQtuprgV+Dzval7dQW3Se+Z1mv6A
	 G0G6LYvocxGaztnQTdmRTYLkA/jOG7JoFkDZZcxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/227] thermal: int340x: Add NULL check for adev
Date: Tue,  8 Apr 2025 12:48:20 +0200
Message-ID: <20250408104823.995908571@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 2542a3f70e563a9e70e7ded314286535a3321bdb ]

Not all devices have an ACPI companion fwnode, so adev might be NULL.
This is similar to the commit cd2fd6eab480
("platform/x86: int3472: Check for adev == NULL").

Add a check for adev not being set and return -ENODEV in that case to
avoid a possible NULL pointer deref in int3402_thermal_probe().

Note, under the same directory, int3400_thermal_probe() has such a
check.

Fixes: 77e337c6e23e ("Thermal: introduce INT3402 thermal driver")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20250313043611.1212116-1-chenyuan0y@gmail.com
[ rjw: Subject edit, added Fixes: ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/int340x_thermal/int3402_thermal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/intel/int340x_thermal/int3402_thermal.c b/drivers/thermal/intel/int340x_thermal/int3402_thermal.c
index 43fa351e2b9ec..b7fdf25bfd237 100644
--- a/drivers/thermal/intel/int340x_thermal/int3402_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3402_thermal.c
@@ -45,6 +45,9 @@ static int int3402_thermal_probe(struct platform_device *pdev)
 	struct int3402_thermal_data *d;
 	int ret;
 
+	if (!adev)
+		return -ENODEV;
+
 	if (!acpi_has_method(adev->handle, "_TMP"))
 		return -ENODEV;
 
-- 
2.39.5



