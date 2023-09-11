Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C164B11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4531CC433C9;
	Mon, 11 Sep 2023 14:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444228;
	bh=ulAQ5w9EP5Hn8jwgTw9BW7iQgfvJwU0kVDkPdMwCCqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VboJ0pKTUizmef0ZxYwrL6hI4hbn9Zv07mx5NquqT5VJw0AoXT8G5o+9Gkd943KXW
	 34sBjM4mBBrWuFOfvVY8Z7Qfi5G6ofX4gywuoEqFMCAxaxjcSP+C40QocsNd6QAHjP
	 zyTtV6yuaYSPCmRxoWG6Ye3D3PkWtABMjWa6avk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.4 656/737] riscv: Move create_tmp_mapping() to init sections
Date: Mon, 11 Sep 2023 15:48:35 +0200
Message-ID: <20230911134708.854520534@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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


