Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3485B350820;
	Tue, 26 Aug 2025 13:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216080; cv=none; b=czImsPeW8y+pv8jsnRyRQ/M31aZvWb8O/EgQLjZPXebDzpgAay5YGyWtNIDFimBVqzEJlSVIUaBJixFKgtSxymJnE9+1mocp6NILoQU0Gur7Wd835kgXb7L9TzXRWYbup7B9lleYJzkX8VpZ4dk+1z4iNaPKkLm7oomimXjm96Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216080; c=relaxed/simple;
	bh=3lCbltzs1CnNgOsbZPM8fHjyIyap84N8mw8DiGDuuaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iC5nAsReIIRRGZriU5C6mZ0VvKe2Fj15qPFI+zuZcjzEUdglmUB+HoeIPNOVGSdJPx+QQbI/A7Zm0ElzEBIySTOisxke4OaMlFesKslRDxU6QnCpmyEZ7ZvSxbXoQSwFRK0ehjhplXDRrP8q6vWzqjzJ6PjpPJL8QoqjW0bKqx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pgq9FjLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pgq9FjLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6903DC113CF;
	Tue, 26 Aug 2025 13:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216079;
	bh=3lCbltzs1CnNgOsbZPM8fHjyIyap84N8mw8DiGDuuaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pgq9FjLCMT6w59HI92SBEJg6WexuzqT1rw1XJqGEtPu7qkvvy5AX3+1CLFH6RMNHi
	 o2XC+Hbl/JL0K2zqlTJ2MDlbv0jHjCK0xp8b/vSqeUzD72mpymnoakqORULekqPz/x
	 4G9Jey5gRlpEZRMjrztp57zr4/zwSU9caScrdKJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 277/644] intel_idle: Allow loading ACPI tables for any family
Date: Tue, 26 Aug 2025 13:06:08 +0200
Message-ID: <20250826110953.239938978@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Len Brown <len.brown@intel.com>

[ Upstream commit e91a158b694d7f4bd937763dde79ed0afa472d8a ]

There is no reason to limit intel_idle's loading of ACPI tables to
family 6.  Upcoming Intel processors are not in family 6.

Below "Fixes" really means "applies cleanly until".
That syntax commit didn't change the previous logic,
but shows this patch applies back 5-years.

Fixes: 4a9f45a0533f ("intel_idle: Convert to new X86 CPU match macros")
Signed-off-by: Len Brown <len.brown@intel.com>
Link: https://patch.msgid.link/06101aa4fe784e5b0be1cb2c0bdd9afcf16bd9d4.1754681697.git.len.brown@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/idle/intel_idle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 359272ce8e29..96002f35405e 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1194,7 +1194,7 @@ static const struct x86_cpu_id intel_idle_ids[] __initconst = {
 };
 
 static const struct x86_cpu_id intel_mwait_ids[] __initconst = {
-	X86_MATCH_VENDOR_FAM_FEATURE(INTEL, 6, X86_FEATURE_MWAIT, NULL),
+	X86_MATCH_VENDOR_FAM_FEATURE(INTEL, X86_FAMILY_ANY, X86_FEATURE_MWAIT, NULL),
 	{}
 };
 
-- 
2.50.1



