Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F15415F2B;
	Tue, 21 Jul 2026 18:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656974; cv=none; b=XdsNTObQxzttzv5OmpTxwHufC0+KMyvdIloXIK0AgD+m7Z1V8jVXSjmDsuXXWOkV2IPHbB4FbNzIQMQCGw34ueJh+AUNwvxc+2MGzXAUaWEQ0U/VFuQ3NqL8XKW+AmYpOLJAkkMwAGIfdC16YcBFH6OepxEeGuGvoGIHuQcnZBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656974; c=relaxed/simple;
	bh=fuVGTo+eVqZL+tJk7frZhdOlM1MBtGbZgJN7W6/gNNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UfccIanNLBxeaIkpLY94xMb8iff5o6vWKB+HpmhZrZDTsBLcKJ9LKK4lOW977uLU38eYa1mXHIENI56Eme6ve0IQn3yyba7pPfp+caVv5h6Sp2qe4bLDL/PToqn0i43aiCrlbt/96dNhR+4MlxxhgPsKtYwWno3pc/Ikw5JGOO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCN3J0nO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCN3J0nO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2428A1F000E9;
	Tue, 21 Jul 2026 18:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656973;
	bh=1AraldXGSfyw9qEPwd6njTvJ0Z9g5lnKdNKhlWK9UJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCN3J0nO4XmT9Xh/IvwNcDvXpXj/5LDlS/Ab+rktf1m30L2kuyW7YGaw9F9AbO1BW
	 4pvrRoSvdlVY0nhaL4jDnbjcZmKo+ZZXzdihHa9PIdXeMLBvDexUuIpfo1GeLK49js
	 e3Uy/2Mhd0PJ+JSU09oefo/vcx2gALlZcWXwFcS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0588/1611] x86/platform/olpc: xo15: Drop wakeup source on driver removal
Date: Tue, 21 Jul 2026 17:11:44 +0200
Message-ID: <20260721152528.608185558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 68244a3422d1d6..683935da493d27 100644
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -185,6 +185,7 @@ static int xo15_sci_add(struct acpi_device *device)
 
 static void xo15_sci_remove(struct acpi_device *device)
 {
+	device_init_wakeup(&device->dev, false);
 	acpi_disable_gpe(NULL, xo15_sci_gpe);
 	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
 	cancel_work_sync(&sci_work);
-- 
2.53.0



