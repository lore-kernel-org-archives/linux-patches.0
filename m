Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36C71DE4C2;
	Tue, 26 Aug 2025 12:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212751; cv=none; b=iz5qjfzAtnnmmk0Xj6dEldtpDmLIv4yvWfNnG7KZrtJNIIyEXCRGXaJvWpVa0ZSwXMjhwPT4y0ZakS2EGor4HcXrG9XBDzXzTF5f4zN/yUK/GyNATQINmk2PbI5A/HeEuc9EZk4KvqMn9AhhqwooSv3EusrGM4FmDayQjGr2d14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212751; c=relaxed/simple;
	bh=4Pw7T+VdSrrlIvZlKYrGVjNIdnWi+KGQ/y1eI7JGzcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raGqoXL/B40anvfJJtKrRguoKnFQpMqe+4u+UdM4eSaElUVaRV/k3+AOd6Uyr222LniAvaUH0J5Oz83n2wdD3ZrVH1pbd+1Uc0j9O6RyAr0e6OB/Qb6dsHMiWH9YP433+oT/zTt7jkB5piRQcLYacv94R8tdDj3D3EMec1FgFZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YH/xn73/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YH/xn73/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CF0C4CEF1;
	Tue, 26 Aug 2025 12:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212751;
	bh=4Pw7T+VdSrrlIvZlKYrGVjNIdnWi+KGQ/y1eI7JGzcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YH/xn73/0aTRckjrEejSVimNDfamwF9pjGqDyyi7cOOgC987EHA0cf3YI5u3noECL
	 DcxSaXcBsof2aNN9lk3RMZ9QEuHvKhPbfDZJ43EGajXHztkapsHQGiz6bsFD4oH6A5
	 aR+MgHZYcj6R4TdZIDxtB0sEw5uWPc53ggeTpS+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/587] intel_idle: Allow loading ACPI tables for any family
Date: Tue, 26 Aug 2025 13:03:27 +0200
Message-ID: <20250826110954.414726829@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
index 44842f243f40..6908052dea77 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1432,7 +1432,7 @@ static const struct x86_cpu_id intel_idle_ids[] __initconst = {
 };
 
 static const struct x86_cpu_id intel_mwait_ids[] __initconst = {
-	X86_MATCH_VENDOR_FAM_FEATURE(INTEL, 6, X86_FEATURE_MWAIT, NULL),
+	X86_MATCH_VENDOR_FAM_FEATURE(INTEL, X86_FAMILY_ANY, X86_FEATURE_MWAIT, NULL),
 	{}
 };
 
-- 
2.50.1



