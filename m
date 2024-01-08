Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A445C4B5AE;
	Mon,  8 Jan 2024 15:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="riE2ArXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098FAC433B7;
	Mon,  8 Jan 2024 15:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726757;
	bh=XXG9oARID7evYSUHzcnp+EG7o0gpSNxNiyIxBaGyI0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=riE2ArXzMXFFLgcLWzdgljUafIgC6H8GmzWrxdMqriyNy/9SmMA2zWGsp2O21Ls4A
	 g8O4VzR8PWUAZKaGuTrR1oKI0G9UWGewtF3UK3HmiFe9IgekqJ3JY1IQtyWRiSc1Ta
	 Z5zFRAwdRgLPMRJdSdQaPJlNURoG3vo4Meqy74hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denys Zagorui <dzagorui@cisco.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <quentin@isovalent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/124] bpftool: Fix -Wcast-qual warning
Date: Mon,  8 Jan 2024 16:08:15 +0100
Message-ID: <20240108150606.148195971@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denys Zagorui <dzagorui@cisco.com>

[ Upstream commit ebc8484d0e6da9e6c9e8cfa1f40bf94e9c6fc512 ]

This cast was made by purpose for older libbpf where the
bpf_object_skeleton field is void * instead of const void *
to eliminate a warning (as i understand
-Wincompatible-pointer-types-discards-qualifiers) but this
cast introduces another warning (-Wcast-qual) for libbpf
where data field is const void *

It makes sense for bpftool to be in sync with libbpf from
kernel sources

Signed-off-by: Denys Zagorui <dzagorui@cisco.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/bpf/20230907090210.968612-1-dzagorui@cisco.com
Stable-dep-of: 23671f4dfd10 ("bpftool: Align output skeleton ELF code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/gen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 2883660d6b672..04c47745b3ea5 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1209,7 +1209,7 @@ static int do_skeleton(int argc, char **argv)
 	codegen("\
 		\n\
 									    \n\
-			s->data = (void *)%2$s__elf_bytes(&s->data_sz);	    \n\
+			s->data = %2$s__elf_bytes(&s->data_sz);		    \n\
 									    \n\
 			obj->skeleton = s;				    \n\
 			return 0;					    \n\
-- 
2.43.0



