Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9221170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B69C433C7;
	Mon, 11 Sep 2023 14:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442124;
	bh=yE4fTJPfI1V4EAK+jbRzrVA7bNyraYlwZk5jvFLAieY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I17WvwMy5NRAbVbvaA+2Krih+fWFthXljJFPASVfg0I+zH3V7lhPQ99sX+h2v4Eun
	 8ppqjn6yo76naTWoHVyHQt/KQu8a/kfAT26oCtDVlg7rUq4438IELSEpbD9zqeG4Rs
	 0sax3jv7ciVPUE1qkk3U7xe2XQ0NVekihd1eU5Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.5 655/739] riscv: Move create_tmp_mapping() to init sections
Date: Mon, 11 Sep 2023 15:47:34 +0200
Message-ID: <20230911134709.406562358@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit 9bdd924803787ceeb10f1ea399e91d75fb05d3a7 upstream.

This function is only used at boot time so mark it as __init.

Fixes: 96f9d4daf745 ("riscv: Rework kasan population functions")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20230704074357.233982-2-alexghiti@rivosinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/kasan_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -438,7 +438,7 @@ static void __init kasan_shallow_populat
 	kasan_shallow_populate_pgd(vaddr, vend);
 }
 
-static void create_tmp_mapping(void)
+static void __init create_tmp_mapping(void)
 {
 	void *ptr;
 	p4d_t *base_p4d;


