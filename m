Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787D1346A0C;
	Tue, 21 Jul 2026 21:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669233; cv=none; b=UBYd2YFp69qsyRzSVehcveet+u2kgOFo3FC+fuWyh+OnCRMBauab0ajCuP6Q9F4kBY1btrM/V9gg99jYSbgZ6a0H15njqBtYrO9c1DMrPVtdzEsSdFlJWLgeaSLDntk8yN+d8NGS3pqus6AAGc7UqffCg+aM2sWBlXpmrqVDjxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669233; c=relaxed/simple;
	bh=YHTs9LqWa0vSnLW6aOWRgCiRtVGQERKiy9Bv2hMIo7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xrl/GD5pOkmsySR88ktVfu84P2+r0JLSSwrYKQM1z/A/bb37buQVhwZzJ9nyvlp4LTOHmbqDjjlu2ZV851rQ2oZeUTMsXmQCXwTwMoTr9IMJiY/GtNETMLJkc93c7+PsliBStSvF3PdbQkhsccyWSOAH1PBuc2exhlI//6l8Ll0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wv1LJGzc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wv1LJGzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD87C1F000E9;
	Tue, 21 Jul 2026 21:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669232;
	bh=718aJxQEHrsH75lLkv6UNRruWXwjWylmzfQicrIFEfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wv1LJGzcI0zsmFsvO68WAHsak7S/UM39ZiJs4nFpqnOz4cVelk3R3JvTskmF2a/iu
	 LVj4Bj5zcu2PQ8Ioy+tNlDfnWqjev926LTquHLoE7Edekk0oUm3msFpOXoIcRNAQvb
	 D/SqTfw1y1s9R/MJGH7+5mdmcItCXNmkvu6GAEYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0478/1067] x86/platform/olpc: xo15: Drop wakeup source on driver removal
Date: Tue, 21 Jul 2026 17:17:59 +0200
Message-ID: <20260721152435.304996915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit cc966553e6ff0849978b5754531b768b0ff54985 ]

Prevent leaking a wakeup source object after removing the driver by
adding appropriate cleanup code to its remove callback function.

Fixes: a0f30f592d2d ("x86, olpc: Add XO-1.5 SCI driver")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2069931.usQuhbGJ8B@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/olpc/olpc-xo15-sci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/platform/olpc/olpc-xo15-sci.c b/arch/x86/platform/olpc/olpc-xo15-sci.c
index 994a229cb79fe1..76ba025a545c79 100644
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -185,6 +185,7 @@ static int xo15_sci_add(struct acpi_device *device)
 
 static int xo15_sci_remove(struct acpi_device *device)
 {
+	device_init_wakeup(&device->dev, false);
 	acpi_disable_gpe(NULL, xo15_sci_gpe);
 	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
 	cancel_work_sync(&sci_work);
-- 
2.53.0



