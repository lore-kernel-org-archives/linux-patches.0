Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853EB46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A516C433D2;
	Mon, 16 Jan 2023 16:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885709;
	bh=WqXCNM8e2JOAaSm9hO5sOOrv/C98ZtNtqiUbyI+LPL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e16vqbLvoLQZWbGWxBwTkO+S4PnZlZjEGyUA5JW/24rfIEM1EKqv4hH1oFZTKFFYj
	 3frNInuAKlC3jC3wzAdDAd6ydAbuZyVbcBpoT3R0yBQYcruIEwXn7a9lI3NvghMxUr
	 lYV+QU76nQX6wGLo/SVkaf4JXiPzbz3oIGwC/MrA=
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
Subject: [PATCH 5.4 125/658] net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
Date: Mon, 16 Jan 2023 16:43:33 +0100
Message-Id: <20230116154915.183915053@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 865d02c224ad..b8d41d0e7b46 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -127,8 +127,10 @@ static inline void proc_remove(struct proc_dir_entry *de) {}
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



