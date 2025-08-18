Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094FF32253A;
	Mon, 18 Aug 2025 13:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523100; cv=none; b=aVEfoaQJCT8lDNJUuCnsXZ35ecvyIz+Kxi9ckfA0+lkEeodtHSvYqSj6mEZ2ojj/iXo4kRwBlxWougQcLbgxHdVEj8AuWg5rHFqX3T+xEXOuGYC0LbpTgZDHfhSGextqhT8MJv9gxk0KTjp4oSpV1BNVMHwndn1NSOH10ttKNYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523100; c=relaxed/simple;
	bh=JdwayqzvnxvLlIDKcbXM4ZBDqtItUNpdrdvLDTYKPyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X15ADao+hZfnEH802Mmb9f55kbWC0mejY9fzEB9219g0On/Npyo2Z4Kx+vN6bbu+8CuG1YrR+m7ICvFWiKMVcPDrkp06qe59c+skhop0kb3X1a5deSnobfPApxHi4Y1VgiB27Vc4bbnjPEwfLG0MMcr0Gd4o9YNET/xw6AxLyds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMNnvFDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMNnvFDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3D2C4CEEB;
	Mon, 18 Aug 2025 13:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523099;
	bh=JdwayqzvnxvLlIDKcbXM4ZBDqtItUNpdrdvLDTYKPyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMNnvFDCP9KsqsTh0qZQMtYFxEFY9nBRWjDCI7iCktnFYGxtHT+zQgdfEo8DXDnJ1
	 KjQ/U1rAHcTvUmiTHhti/iPwMmoX0kzvq1mh4sy6KKflEbwcOWAld2sTMaN6MU/U2Q
	 7ZMQLeLwk38oM1YnTqeocg02qPozQ1YmjgAj8ilw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 070/515] intel_idle: Allow loading ACPI tables for any family
Date: Mon, 18 Aug 2025 14:40:56 +0200
Message-ID: <20250818124501.087909154@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 976f5be54e36..039dc42dd509 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1665,7 +1665,7 @@ static const struct x86_cpu_id intel_idle_ids[] __initconst = {
 };
 
 static const struct x86_cpu_id intel_mwait_ids[] __initconst = {
-	X86_MATCH_VENDOR_FAM_FEATURE(INTEL, 6, X86_FEATURE_MWAIT, NULL),
+	X86_MATCH_VENDOR_FAM_FEATURE(INTEL, X86_FAMILY_ANY, X86_FEATURE_MWAIT, NULL),
 	{}
 };
 
-- 
2.50.1



