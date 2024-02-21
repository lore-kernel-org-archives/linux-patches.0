Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C816769954;
	Wed, 21 Feb 2024 13:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521057; cv=none; b=o8gcBfTrdbt81JVI8NJYb7mLwO7DP8Qf2m6YiE9OkF/cguD+OrX1pLUYJDUJWYzYZRXEPpQFrYz07c/w++qwD2+BRxVWNBWx5j7Dhr3+2/euTYcvSD93CVXMuW5nujqq9QIo9qbad7ngE2WbKpbBWrRM/BnplPcuvDqf59VC1Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521057; c=relaxed/simple;
	bh=/SQ3J1eerQX3jkU33eY1tkCooqzV9c4pbrL26sx2NBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejcl1rJhvbK3YMgr79HHvoCjrOxxcuhst2Q/tYNZWQz1I0g9qthauhvlq028RAGFeJqpPU27i92NXTeLgQueCvzeydvap3VaYMVexILgQ4anmlNbM44v8YmJh+E0He5E/a1FW8NmQ76v/49bGQPTtMouUUmN2UXsZNq6z9MfVvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlBFIt6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlBFIt6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C8EC433C7;
	Wed, 21 Feb 2024 13:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521057;
	bh=/SQ3J1eerQX3jkU33eY1tkCooqzV9c4pbrL26sx2NBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlBFIt6igKzORwEBrxq8OgAfbXGzZOyk3RI9TMq0zUcw21TExp/BmDHQvF0qyGbpY
	 WD1M+VZ29iGyQAVJyc99Rj4DjmJ7fQDAaa/PPIBfKXpvk71vNpeoM6FFLvkuaIC4lS
	 rbZDWvaz4td4W65r68ArtJlJZXK1TYSYSUgGAHUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 003/202] units: Add Watt units
Date: Wed, 21 Feb 2024 14:05:04 +0100
Message-ID: <20240221125931.851676624@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Lezcano <daniel.lezcano@linaro.org>

[ Upstream commit 2ee5f8f05949735fa2f4c463a5e13fcb3660c719 ]

As there are the temperature units, let's add the Watt macros definition.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 3ef79cd14122 ("serial: sc16is7xx: set safe default SPI clock frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/units.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/units.h b/include/linux/units.h
index aaf716364ec3..92c234e71cab 100644
--- a/include/linux/units.h
+++ b/include/linux/units.h
@@ -4,6 +4,10 @@
 
 #include <linux/kernel.h>
 
+#define MILLIWATT_PER_WATT	1000L
+#define MICROWATT_PER_MILLIWATT	1000L
+#define MICROWATT_PER_WATT	1000000L
+
 #define ABSOLUTE_ZERO_MILLICELSIUS -273150
 
 static inline long milli_kelvin_to_millicelsius(long t)
-- 
2.43.0



