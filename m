Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15CC10944
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397DEC433C8;
	Mon, 19 Jun 2023 10:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170902;
	bh=1rA60v34VpalHgNbi1f2EV+1rMNTKszrS8EJULrYUgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEzqZQM8JFxn3pPj2+SLYdG3WJr1GmtHhucgTXlKnBBEPI1t9/ZslzlsaLG5c6mAa
	 WM6Yh3knvJZuO5A8d9xMyBsQt7lCVwNTT5rNbhfLTdngeE43tYcJ7nzUl7MDaNN8BO
	 TcyZQTku5xV28ha9HfE5noL+ZMq2RnBovtORuv9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Li <haibo.li@mediatek.com>,
	David Hildenbrand <david@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.3 077/187] mm/gup_test: fix ioctl fail for compat task
Date: Mon, 19 Jun 2023 12:28:15 +0200
Message-ID: <20230619102201.353391346@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haibo Li <haibo.li@mediatek.com>

commit 4f572f0074b8be8a70bd150d96a749aa94c8d85f upstream.

When tools/testing/selftests/mm/gup_test.c is compiled as 32bit, then run
on arm64 kernel, it reports "ioctl: Inappropriate ioctl for device".

Fix it by filling compat_ioctl in gup_test_fops

Link: https://lkml.kernel.org/r/20230526022125.175728-1-haibo.li@mediatek.com
Signed-off-by: Haibo Li <haibo.li@mediatek.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -381,6 +381,7 @@ static int gup_test_release(struct inode
 static const struct file_operations gup_test_fops = {
 	.open = nonseekable_open,
 	.unlocked_ioctl = gup_test_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.release = gup_test_release,
 };
 


