Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ACA2ECE81;
	Tue, 17 Jun 2025 15:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175101; cv=none; b=Wfh9W1jWYJ4WCgAcp6FusdNlhJItG2AYP+yubxX0bgJhPSZOoBOFBOHH2CU0J9kisY3uqc5OtaR/pXWgeH+2CnFu5X+Bu+5aVjZGMRcorMPGjlk83GBotQPQsELN1XIrxVjlpW67Q9Xjuu1KA2BJOuU8jJebe1IIkSevxZ5mZGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175101; c=relaxed/simple;
	bh=4HDVizlx01AD8M1apxipEPYGJ4zsrrPrLspJkmdJZ6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlhsoZuY1PYk3b6UzHDwZjfYr2MzogfhNA4OT/Ib/6vbaiOduihuKAVSFg7LwCk3btkwZ3YRx8voKcTX2vWbksYcoouZbr76rfMxIRdyqO3UiQGNo2HH+LRnfHXa0+JGx909tVxrF1pYHDJIYhIr6VmCSKtdQo6avBpsotthxa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSlW4VDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSlW4VDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4394C4CEE3;
	Tue, 17 Jun 2025 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175101;
	bh=4HDVizlx01AD8M1apxipEPYGJ4zsrrPrLspJkmdJZ6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSlW4VDwuAVESshzsRdLX80hTaPEJqDhyYALH/KGrwb3BYfZ0ZS5Lcfz+MzMSVa8g
	 EZpSTNMHfh/j0Woj5IYSAXWcprR5HVCqxXJ5SayjPY0Y0xGsoU73/mZ3SzUsNrN9jY
	 iJZrVA4WtV4/6AP61FzUvijKWpgBJxozxS8O7W3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 049/780] kunit: Fix wrong parameter to kunit_deactivate_static_stub()
Date: Tue, 17 Jun 2025 17:15:57 +0200
Message-ID: <20250617152453.497813700@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 772e50a76ee664e75581624f512df4e45582605a ]

kunit_deactivate_static_stub() accepts real_fn_addr instead of
replacement_addr.  In the case, it always passes NULL to
kunit_deactivate_static_stub().

Fix it.

Link: https://lore.kernel.org/r/20250520082050.2254875-1-tzungbi@kernel.org
Fixes: e047c5eaa763 ("kunit: Expose 'static stub' API to redirect functions")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/static_stub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kunit/static_stub.c b/lib/kunit/static_stub.c
index 92b2cccd5e763..484fd85251b41 100644
--- a/lib/kunit/static_stub.c
+++ b/lib/kunit/static_stub.c
@@ -96,7 +96,7 @@ void __kunit_activate_static_stub(struct kunit *test,
 
 	/* If the replacement address is NULL, deactivate the stub. */
 	if (!replacement_addr) {
-		kunit_deactivate_static_stub(test, replacement_addr);
+		kunit_deactivate_static_stub(test, real_fn_addr);
 		return;
 	}
 
-- 
2.39.5



