Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161CA6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFD1C433D2;
	Mon, 16 Jan 2023 16:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887412;
	bh=4wxufKjU7ZegNh2d9q87jhOAIGrO7e2mCzauAT3i8pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHeFcw9xzoRMLbyRf/YOPbrL36IlnVuIWM00p3lMcaTIv/CErjhxPZF767vjUj1AZ
	 /mi6L6u0snQ9YKY4C2nkra2t+VuJIYjdGq6z7lwIhGuaycS7sCC4+/0PUWW3ZX0Hks
	 blWOH/ulBS8JG2LqJv8tPNCzZ0somzUCMlWtd+5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/521] net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
Date: Mon, 16 Jan 2023 16:46:02 +0100
Message-Id: <20230116154851.724914341@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit c3d96f690a790074b508fe183a41e36a00cd7ddd ]

Provide a CONFIG_PROC_FS=n fallback for proc_create_net_single_write().

Also provide a fallback for proc_create_net_data_write().

Fixes: 564def71765c ("proc: Add a way to make network proc files writable")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/proc_fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 5141657a0f7f..c16352fbbe1f 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -117,8 +117,10 @@ static inline void proc_remove(struct proc_dir_entry *de) {}
 static inline int remove_proc_subtree(const char *name, struct proc_dir_entry *parent) { return 0; }
 
 #define proc_create_net_data(name, mode, parent, ops, state_size, data) ({NULL;})
+#define proc_create_net_data_write(name, mode, parent, ops, write, state_size, data) ({NULL;})
 #define proc_create_net(name, mode, parent, state_size, ops) ({NULL;})
 #define proc_create_net_single(name, mode, parent, show, data) ({NULL;})
+#define proc_create_net_single_write(name, mode, parent, show, write, data) ({NULL;})
 
 #endif /* CONFIG_PROC_FS */
 
-- 
2.35.1



