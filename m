Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AF433F5B4;
	Thu, 28 May 2026 20:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999049; cv=none; b=ZXPQuhSEQSAPETu/9S4qpkKcB7+rLCaFVnoQ0lxbgBm+YlMos+HA/dXd2RMW4NSLlG092otkCq97kXsjBTAxO06Ivv9ohIo6whfc5ZclulZBbXJcv/gA9XCjDqFb61bZsYKyvEs1h+X60k9kK0Pm5pnisqZwqywwpSzv/npRvcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999049; c=relaxed/simple;
	bh=m0aek1j3oxfpGS1WfWT3bLg68x9do9ibq72znJK7G4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KtLssFA2ARcNqXC93w1LhLSj0VUpzeJTfkHUjzIz/JPwnA7cFUfj/0xtTOAndWnU9GE9x7/E8ZBY8l+wRt9nEC4O0wTUDjHtzqhLoLloMF1IWx/BeI8BOVzGgS5FteFcP1BN3EwcmOP9m6YqB2nmJPOzCPh3mqRGvvEvgx2+ofw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+3FqP+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+3FqP+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293881F000E9;
	Thu, 28 May 2026 20:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999048;
	bh=k+j+CFXFavEbbNcPEHRMPzPy82wPPLYDJD1i4SVg/UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+3FqP+2DNAKsp6daDFmLtJXkWLwWQR3ZiuKesBMqYQsenZsvx72kMYp97CuLdU7j
	 KccskwPkn6SFYsndwBG5GafzKcJSmD9+Kw86j1Uxr8WO4bue4kxPgXXzQddnFiKi3o
	 6pmyizjxuiyXd1V0IuMBiIUlry1mD8d2fjA8NvwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 389/461] platform/x86: hp_accel: Check ACPI_COMPANION() against NULL
Date: Thu, 28 May 2026 21:48:38 +0200
Message-ID: <20260528194658.721749870@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit abfbe5ee8ae89f1f5449790423d5dd3e423545bd ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_COMPANION() check against NULL to the
platform/x86 hp_accel driver.

Fixes: 8ebcb6c94c71 ("platform/x86: hp_accel: Convert to be a platform driver")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/2425918.ElGaqSPkdT@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp_accel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/hp/hp_accel.c b/drivers/platform/x86/hp/hp_accel.c
index 10d5af18d6398..39b73dc473f1c 100644
--- a/drivers/platform/x86/hp/hp_accel.c
+++ b/drivers/platform/x86/hp/hp_accel.c
@@ -300,6 +300,9 @@ static int lis3lv02d_probe(struct platform_device *device)
 	int ret;
 
 	lis3_dev.bus_priv = ACPI_COMPANION(&device->dev);
+	if (!lis3_dev.bus_priv)
+		return -ENODEV;
+
 	lis3_dev.init = lis3lv02d_acpi_init;
 	lis3_dev.read = lis3lv02d_acpi_read;
 	lis3_dev.write = lis3lv02d_acpi_write;
-- 
2.53.0



