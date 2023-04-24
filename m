Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CD47C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22302C4339C;
	Mon, 24 Apr 2023 13:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342798;
	bh=yNf+6MgrW2TLuDgOW6ptHVlZmMXDPGptF4rVUsUo/sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i35gJ0tegrujsRYjyL7aYl7wri6IebBsuRXhLFK+hvJLQ+fOB3Dga2iNUJOKJI+70
	 AixPG6tSGgulGehPZydpqMrKCVW/R/FlW0XWrHtihs1CPWIx5MrcYDwUY/L8XBsmri
	 g3woXZsKZh0GmDs+RNM+d2Db9icTR8JXoOgXZti0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Chou <steve_chou@pesi.com.tw>,
	Jiajian Ye <yejiajian2018@email.szu.edu.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 62/98] tools/mm/page_owner_sort.c: fix TGID output when cull=tg is used
Date: Mon, 24 Apr 2023 15:17:25 +0200
Message-Id: <20230424131136.259770319@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve Chou <steve_chou@pesi.com.tw>

commit 9235756885e865070c4be2facda75262dbd85967 upstream.

When using cull option with 'tg' flag, the fprintf is using pid instead
of tgid. It should use tgid instead.

Link: https://lkml.kernel.org/r/20230411034929.2071501-1-steve_chou@pesi.com.tw
Fixes: 9c8a0a8e599f4a ("tools/vm/page_owner_sort.c: support for user-defined culling rules")
Signed-off-by: Steve Chou <steve_chou@pesi.com.tw>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/vm/page_owner_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/vm/page_owner_sort.c
+++ b/tools/vm/page_owner_sort.c
@@ -847,7 +847,7 @@ int main(int argc, char **argv)
 			if (cull & CULL_PID || filter & FILTER_PID)
 				fprintf(fout, ", PID %d", list[i].pid);
 			if (cull & CULL_TGID || filter & FILTER_TGID)
-				fprintf(fout, ", TGID %d", list[i].pid);
+				fprintf(fout, ", TGID %d", list[i].tgid);
 			if (cull & CULL_COMM || filter & FILTER_COMM)
 				fprintf(fout, ", task_comm_name: %s", list[i].comm);
 			if (cull & CULL_ALLOCATOR) {


