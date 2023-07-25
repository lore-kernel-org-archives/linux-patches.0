Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBC91D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CF7C433C7;
	Tue, 25 Jul 2023 11:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283180;
	bh=E4K5GKOBXmBHOs/AJ1W4VoAHka+ZnYpQrYnrDzF6WkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rF613tX3I1Seqxmrn2aI87qPTCsnrKnwYSLWkKda5RI9FrdVfzVhJZPwcOo91yHw9
	 0l0qnHJcnks0C0qWcgL5jVHZ6LLGqw5qy4TYm/CT8vkAj7feI9GZCMlGcCYID27F94
	 wHfMYFUvnIhIQbfxWP4FdQog9dGKHu3vM7A3aIQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.1 168/183] kallsyms: add kallsyms_seqs_of_names to list of special symbols
Date: Tue, 25 Jul 2023 12:46:36 +0200
Message-ID: <20230725104513.822874381@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit ced0f245ed951e2b8bd68f79c15238d7dd253662 upstream.

My randconfig build setup ran into another kallsyms warning:

Inconsistent kallsyms data
Try make KALLSYMS_EXTRA_PASS=1 as a workaround

After adding some debugging code to kallsyms.c, I saw that the recently
added kallsyms_seqs_of_names symbol can sometimes cause the second stage
table to be slightly longer than the first stage, which makes the
build inconsistent.

Add it to the exception table that contains all other kallsyms-generated
symbols.

Fixes: 60443c88f3a8 ("kallsyms: Improve the performance of kallsyms_lookup_name()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/kallsyms.c |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -118,6 +118,7 @@ static bool is_ignored_symbol(const char
 		"kallsyms_markers",
 		"kallsyms_token_table",
 		"kallsyms_token_index",
+		"kallsyms_seqs_of_names",
 		/* Exclude linker generated symbols which vary between passes */
 		"_SDA_BASE_",		/* ppc */
 		"_SDA2_BASE_",		/* ppc */


