Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1322EF664;
	Fri, 10 Oct 2025 13:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102413; cv=none; b=c+zwGjLfIbbeDsbYtk6ZFjdn4RIJ5D5UwK23sEPdafgQqpK3S+Gr8v78Mgur0Hc44C890lwWtiW4/pFW+RyZD+LcWmSkmGQR16Qz1cKNI1VtcYqskqag4x+66yzW8Qgzgx7MEWA2ki5c/gPbScOylcPIi7SB/NkKXLfkK6axgN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102413; c=relaxed/simple;
	bh=JnAcFamxAWZ6EX22O7GEmTXb15OIzihsuZ7+zNmo3K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6kOLzsYxYsF1ulA93w8xWyMqOiBY9AatKXy72Uj+yIg1ra/z7MwyJ852qS3OThTwNDbv/gGxkxmV2be97eurXFcJlAsUNqVrUQXUfGfUWjo/6u9ORu3g1l0zV7uGnwrdTs4Szlqbf9TDgCGAzywPyvwiRn9Pbd35Y+Wfev2heo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNWTwLXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNWTwLXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC5AC4CEF1;
	Fri, 10 Oct 2025 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102413;
	bh=JnAcFamxAWZ6EX22O7GEmTXb15OIzihsuZ7+zNmo3K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNWTwLXVkDt2KrJio7h8zJv+jh/BqoOm9Jj+snHWv9TBPwR9L9ibFVLo9zaRSwzlZ
	 5jPAMgaON8nuE9FwKMS20GvJEYXDz9uh3O2+jyvs6dkhamSEbJAFjivHqzTM9Lf03w
	 GAuDgb8u2qa4r780uKcAngXDfzp3BHTkTihn94X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	stable <stable@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.16 36/41] driver core: faux: Set power.no_pm for faux devices
Date: Fri, 10 Oct 2025 15:16:24 +0200
Message-ID: <20251010131334.715999280@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 1ad926459970444af1140f9b393f416536e1a828 upstream.

Since faux devices are not supposed to be involved in any kind of
power management, set the no_pm flag for all of them.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/6206518.lOV4Wx5bFT@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/faux.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/base/faux.c
+++ b/drivers/base/faux.c
@@ -155,6 +155,7 @@ struct faux_device *faux_device_create_w
 		dev->parent = &faux_bus_root;
 	dev->bus = &faux_bus_type;
 	dev_set_name(dev, "%s", name);
+	device_set_pm_not_required(dev);
 
 	ret = device_add(dev);
 	if (ret) {


