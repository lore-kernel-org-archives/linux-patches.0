Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0662E2F1E;
	Tue, 15 Jul 2025 13:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586131; cv=none; b=Z42rQ6Ic6f8nVjJrMYW94qFHs6V77+uPszPR1SDnfgrcjiX1NrwTgDSDN6uX9aMoeLSqiWONOf1C5/Yq8+wgn0oqXrGbYazr7gUROveBwdYyupcvzyejy3J+vDbQqNO896CZRe+mL1iAkV1cB3c+IvcE8ySN7J9tTOemg0pkuoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586131; c=relaxed/simple;
	bh=CQNaZBW/pZ48CXGLztlhOJhMHe//4mcpvgXz7s3ReZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xk1MJUXn/H2F0+tWSTwviRNYf/QL0ahEDXF2Fhp4z8AWi1kLQuiFAE9vJyywJimS8fcl5+M52EN+gctPqpKipOtJZbkRMVcyB22er1b/T6KXEKpJCCH2mWmJ2G40dGm6drs0/ErFLy+GHd52m/1Pi315G610UBWK0q5gt1i3q7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mP653EJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mP653EJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F23C4CEF1;
	Tue, 15 Jul 2025 13:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586131;
	bh=CQNaZBW/pZ48CXGLztlhOJhMHe//4mcpvgXz7s3ReZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mP653EJJJkQoqdNk2yns4Desr8R83v6jvWaFhJnPPl1AFuEdJmWFdWfA+eq/CA+js
	 G/UK18AZYBe3WdWF+m/V+uFRcB4MsZobUbk0RTWzqSi72FbyFXlV3oxFum5Pm4As4e
	 QbzgwRf/MLZqnyT5//hUerGi91OjUx7QH3p6EEoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.15 27/77] x86/mce: Dont remove sysfs if thresholding sysfs init fails
Date: Tue, 15 Jul 2025 15:13:26 +0200
Message-ID: <20250715130752.797351265@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 4c113a5b28bfd589e2010b5fc8867578b0135ed7 upstream.

Currently, the MCE subsystem sysfs interface will be removed if the
thresholding sysfs interface fails to be created. A common failure is due to
new MCA bank types that are not recognized and don't have a short name set.

The MCA thresholding feature is optional and should not break the common MCE
sysfs interface. Also, new MCA bank types are occasionally introduced, and
updates will be needed to recognize them. But likewise, this should not break
the common sysfs interface.

Keep the MCE sysfs interface regardless of the status of the thresholding
sysfs interface.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250624-wip-mca-updates-v4-1-236dd74f645f@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/core.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2620,15 +2620,9 @@ static int mce_cpu_dead(unsigned int cpu
 static int mce_cpu_online(unsigned int cpu)
 {
 	struct timer_list *t = this_cpu_ptr(&mce_timer);
-	int ret;
 
 	mce_device_create(cpu);
-
-	ret = mce_threshold_create_device(cpu);
-	if (ret) {
-		mce_device_remove(cpu);
-		return ret;
-	}
+	mce_threshold_create_device(cpu);
 	mce_reenable_cpu();
 	mce_start_timer(t);
 	return 0;


