Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3217C8DD
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3291CC433AB;
	Mon, 19 Jun 2023 10:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172266;
	bh=Ztc0/YyUKCxv2oxuyl++E4/FbJR0kBP9C58Zqb5dEws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjhbfeFJoH3wqzErojfT8A9MO9W6hKITBAl7LlvpY/QqVrPpOheYD4hAyEyEXz0yi
	 VExczcpyi+ywoekw06Qch8q1KrBdB7RVF+BP5qeToHEfrRNGZtRsBYUtp4shWXqWA5
	 7AF12SCxRg8byrTPgOmubJL+uSkWJW2rzgREWSpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.10 89/89] um: Fix build w/o CONFIG_PM_SLEEP
Date: Mon, 19 Jun 2023 12:31:17 +0200
Message-ID: <20230619102142.350713787@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
References: <20230619102138.279161276@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

commit 1fb1abc83636f5329c26cd29f0f19f3faeb697a5 upstream.

uml_pm_wake() is unconditionally called from the SIGUSR1 wakeup
handler since that's in the userspace portion of UML, and thus
a bit tricky to ifdef out. Since pm_system_wakeup() can always
be called (but may be an empty inline), also simply always have
uml_pm_wake() to fix the build.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/kernel/um_arch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -387,12 +387,12 @@ void text_poke_sync(void)
 {
 }
 
-#ifdef CONFIG_PM_SLEEP
 void uml_pm_wake(void)
 {
 	pm_system_wakeup();
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int init_pm_wake_signal(void)
 {
 	/*


