Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72091D0488;
	Wed,  2 Oct 2024 13:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877509; cv=none; b=SNFvq2rgFrmgcPoYRIIOYmcRsx9ZA/bMYEwRmECvA922wYL08roSXKPXjOsDhREanxw+Ul4KLz52L3pWkik70eLqktXo63W/khOhH46CTF5ado2XGdH3kMdfnoNK1lVZUA/y9FIf+Q+pQj0PWMXM6ILnHc6IGPjYfdcuy+VgN1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877509; c=relaxed/simple;
	bh=gMB/0E1jfruo/1lBVpo8SXgwGaN9rLgrqQJZqEVFLaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgsTSdz+MUG/XUzgwIl8EF8Ix23Autl2CIJZy4J18Jmf5m3sJM0jeJYap0oPtfOhh/v690TDJzBQW93ebCov014jkDohoFOLz9gpeO33N1ZZbVs5nUbVlhK4y4ufRbKxi/ngo52YCn7N0SnkWtkcy6CVYdWx/8ivikOi7aeKyD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cW4eUv1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cW4eUv1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1446C4CEC2;
	Wed,  2 Oct 2024 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877509;
	bh=gMB/0E1jfruo/1lBVpo8SXgwGaN9rLgrqQJZqEVFLaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cW4eUv1f3nIOViaGNHIIno1ZE8JtL/O9osXxKD4fJXS2BGN6EPgTh8+AKD56+An7I
	 TV7EZWSTGanVbhMVadg/NhpQHDdiclfWkmA4PAV6caKzpv9OWJSau6qyUkcaypBl8G
	 UMQtFHrCb1kFj4AAUbP6HjsL/bHpzDsRohYpfsFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	"John B. Wyatt IV" <jwyatt@redhat.com>,
	"John B. Wyatt IV" <sageofredondo@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 071/634] pm:cpupower: Add missing powercap_set_enabled() stub function
Date: Wed,  2 Oct 2024 14:52:51 +0200
Message-ID: <20241002125813.910360408@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



