Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AB9749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0526BC433D2;
	Thu, 12 Jan 2023 14:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532476;
	bh=VvXy63uXCcFZrZ8+oipT7MulRH9gIJTrgealz7rgMvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TteLkYEXWRt81eCCPTvoE4W4P7Ml9pmy/SeO0KmAW5XDqOysZFcEOSt90x3ROJ5fq
	 orPFZqB9ZUrvCSNU6eIZqD40OShCwQqkT3ER5x2AGZg6ozD6lxSt9S/O+jgv8WIP4N
	 ZPl97fW4dxLdXOtM5NurdBMXiv76i4E6WY0sS4Kg=
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
Subject: [PATCH 5.10 144/783] net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
Date: Thu, 12 Jan 2023 14:47:40 +0100
Message-Id: <20230112135531.009922223@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 000cc0533c33..8c892730a1f1 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -190,8 +190,10 @@ static inline void proc_remove(struct proc_dir_entry *de) {}
 static inline int remove_proc_subtree(const char *name, struct proc_dir_entry *parent) { return 0; }
 
 #define proc_create_net_data(name, mode, parent, ops, state_size, data) ({NULL;})
+#define proc_create_net_data_write(name, mode, parent, ops, write, state_size, data) ({NULL;})
 #define proc_create_net(name, mode, parent, state_size, ops) ({NULL;})
 #define proc_create_net_single(name, mode, parent, show, data) ({NULL;})
+#define proc_create_net_single_write(name, mode, parent, show, write, data) ({NULL;})
 
 static inline struct pid *tgid_pidfd_to_pid(const struct file *file)
 {
-- 
2.35.1



