Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572CC155A4E;
	Tue, 29 Apr 2025 18:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950641; cv=none; b=ljTgKvRVPJYLqFLzAuzlkkWrIpAvE5Y+m1h8xH7gbq9WPn5A1UHhcbKogBosgv4Erl/UcpVi+KeeG6sutnWduIzMs4S8fDlT1Hr+pP8E8EhpBvOPR3lYXBrKaZPDs1yXanPqAO6VAtFkhbXSdoCui7c/cUbYLLfWt88D1bgN3rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950641; c=relaxed/simple;
	bh=++mJA97+LfkL8YxIZXBni2j5UUu1I4bXB63le8jseDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2DkJJfeymxciTMmaVPmeJfYNcGkaUzKbfPDHSN/dBeh5Yo6Ea1+mpMUy9p5WbjwQyFHx3TwP9ju5V3dGIk3e9/COL/uAAbL6yZSoTnenovAnmY/RrcbtrXPyj42x74n6HWR7SFIlLm5MIDdD0J2WBRASHmXoyg4REx5WpdnGmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQoIBtIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQoIBtIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE74C4CEE3;
	Tue, 29 Apr 2025 18:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950641;
	bh=++mJA97+LfkL8YxIZXBni2j5UUu1I4bXB63le8jseDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQoIBtIEaAtJVGdl4iCsK3i+dDbU3NliUexAnFk1WgtNvuirUUZ0L5jpKO3+F6kJq
	 tl/hJhrlvclow4fQc8g41DYyqLhznBmEWwMT8CdBPGIqBA5PODWfGYbF0TJMdktDZV
	 v9Hv0KzNU/+ITwKrL/rprwidaWQzVc5mG6OxY/Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/204] xen: Change xen-acpi-processor dom0 dependency
Date: Tue, 29 Apr 2025 18:44:06 +0200
Message-ID: <20250429161105.878160561@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Andryuk <jason.andryuk@amd.com>

[ Upstream commit 0f2946bb172632e122d4033e0b03f85230a29510 ]

xen-acpi-processor functions under a PVH dom0 with only a
xen_initial_domain() runtime check.  Change the Kconfig dependency from
PV dom0 to generic dom0 to reflect that.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250331172913.51240-1-jason.andryuk@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index d43153fec18ea..af5c214b22069 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -278,7 +278,7 @@ config XEN_PRIVCMD_IRQFD
 
 config XEN_ACPI_PROCESSOR
 	tristate "Xen ACPI processor"
-	depends on XEN && XEN_PV_DOM0 && X86 && ACPI_PROCESSOR && CPU_FREQ
+	depends on XEN && XEN_DOM0 && X86 && ACPI_PROCESSOR && CPU_FREQ
 	default m
 	help
 	  This ACPI processor uploads Power Management information to the Xen
-- 
2.39.5



