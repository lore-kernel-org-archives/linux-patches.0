Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C901CFEB3;
	Wed,  2 Oct 2024 14:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879238; cv=none; b=tbgWd+2wQ+Ro4hNCLgJmUNTHB/5XTVENfCA3nRPzlAADw/Ye9ALxwVOzFCN/WVL3AHQBfE/Ua6NdlhjTfdSWk67VZF/xC1DBf5QYEN3N4bUmRQNJroQ6APAvN65vlFCzP1RnverpoIVT9HtwkqicjpFOMHjJ4vApCAAp5hihrig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879238; c=relaxed/simple;
	bh=AKrT3QqHge/r27WV3fbsRatroeTONnR0eLjmYiwY4g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9FDmG6Zu3m/jDTyCYmdRYdStgFka1Pf12tvGE9vvaSbNqh7pSnzQzvaQFKpNpGNP6wwVH+AUWf2nm38jmHHIwTuxVczu/znV3jdZS2FLfSnCB4Sib9f8B36WPWdnwKT4fUn3QSBRrlYCbNCTzEfJ/rGwtduEDuXY+mA0jjN6+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTPYe3ui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTPYe3ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0188AC4CEC2;
	Wed,  2 Oct 2024 14:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879238;
	bh=AKrT3QqHge/r27WV3fbsRatroeTONnR0eLjmYiwY4g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTPYe3uijT0lKyCqs03uG4cN4t0OFxTV2NSi/Ex1SP2fxsYUwZMCfoUrEZyboJb27
	 FQPiiIWvgXuLk/5sj5FCkEvd1zUnPRyLUFRp3yRvsZIEfPlK/jfN7NOPE5tn/xHme9
	 XrfGB5Dw+CxWpzeuBwBHtmUxdZDPIig8jZ092wNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	"John B. Wyatt IV" <jwyatt@redhat.com>,
	"John B. Wyatt IV" <sageofredondo@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/538] pm:cpupower: Add missing powercap_set_enabled() stub function
Date: Wed,  2 Oct 2024 14:54:49 +0200
Message-ID: <20241002125754.173545239@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John B. Wyatt IV <jwyatt@redhat.com>

[ Upstream commit 4b80294fb53845dc5c98cca0c989da09150f2ca9 ]

There was a symbol listed in the powercap.h file that was not implemented.
Implement it with a stub return of 0.

Programs like SWIG require that functions that are defined in the
headers be implemented.

Fixes: c2294c1496b7 ("cpupower: Introduce powercap intel-rapl library and powercap-info command")
Suggested-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: John B. Wyatt IV <jwyatt@redhat.com>
Signed-off-by: John B. Wyatt IV <sageofredondo@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/lib/powercap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/power/cpupower/lib/powercap.c b/tools/power/cpupower/lib/powercap.c
index a7a59c6bacda8..94a0c69e55ef5 100644
--- a/tools/power/cpupower/lib/powercap.c
+++ b/tools/power/cpupower/lib/powercap.c
@@ -77,6 +77,14 @@ int powercap_get_enabled(int *mode)
 	return sysfs_get_enabled(path, mode);
 }
 
+/*
+ * TODO: implement function. Returns dummy 0 for now.
+ */
+int powercap_set_enabled(int mode)
+{
+	return 0;
+}
+
 /*
  * Hardcoded, because rapl is the only powercap implementation
 - * this needs to get more generic if more powercap implementations
-- 
2.43.0



