Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBB92C87B;
	Fri, 24 Nov 2023 18:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kuz+P7eL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605C3C433C8;
	Fri, 24 Nov 2023 18:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851948;
	bh=MX4kyyJA37hioBzVZT2yU3Fu38QYTVeKMmN1aqOBe9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kuz+P7eLRYeH9s1bTpH4f+Ss2be4/XR5zVmzUyGCEBjlakBc1MN8BrnOHarA2gx0G
	 NsBLvRI2MP/WHWz7sP/Yq0OyaGl+xi5FCIjb5pnc+GRq4jI/NTDi7UOvdo7hdQlhKl
	 1XGRZ9+Ch0PFVVGXcf5pQJgQxEMUhd6k/R9TQ5BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Anastasia Belova <abelova@astralinux.ru>,
	Ekaterina Esina <eesina@astralinux.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/372] cifs: spnego: add ; in HOST_KEY_LEN
Date: Fri, 24 Nov 2023 17:49:06 +0000
Message-ID: <20231124172015.784406009@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anastasia Belova <abelova@astralinux.ru>

[ Upstream commit ff31ba19d732efb9aca3633935d71085e68d5076 ]

"host=" should start with ';' (as in cifs_get_spnego_key)
So its length should be 6.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Fixes: 7c9c3760b3a5 ("[CIFS] add constants for string lengths of keynames in SPNEGO upcall string")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Co-developed-by: Ekaterina Esina <eesina@astralinux.ru>
Signed-off-by: Ekaterina Esina <eesina@astralinux.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_spnego.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifs_spnego.c b/fs/smb/client/cifs_spnego.c
index 342717bf1dc28..1e6819daaaa7e 100644
--- a/fs/smb/client/cifs_spnego.c
+++ b/fs/smb/client/cifs_spnego.c
@@ -64,8 +64,8 @@ struct key_type cifs_spnego_key_type = {
  * strlen(";sec=ntlmsspi") */
 #define MAX_MECH_STR_LEN	13
 
-/* strlen of "host=" */
-#define HOST_KEY_LEN		5
+/* strlen of ";host=" */
+#define HOST_KEY_LEN		6
 
 /* strlen of ";ip4=" or ";ip6=" */
 #define IP_KEY_LEN		5
-- 
2.42.0



