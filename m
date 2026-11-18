Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034818;
	b=ZNuYZTyGv1RbONNutbRuwkGVWunChOtSl2N68lyDqF/n8NVJE3fXN3Lza4W9N7EDpaHH
	 8mLo0TmOE9e4tMjByRlMDxMwZ+hyoqmJEW5igHzqt7ojhD4/aV8gUXkNaLvSM2M6c6RAM
	 BSGEk6xndtxt7yfZ/t2luEW0LdACz9JCDWfKfDSrcarkT678789MhFhbmCZSvT0fjFFw9
	 AJaYdn6w6UaKDf5fMBAh8eRvS+IF45sANq/rtKfBYPQAmkoGKX2Bh4rX7XHTrzU7RMqUm
	 MwWtDe5qZex6R1OAqQGnblpxP19PE1RMoKoTLHQDmfE9lVzHQwvnPN3Sy9q5PkjOg2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SCaChbcS1b0Vx9mQ05V+dwO5lV79UtNnqTtwfqQ8/es=;
	b=douPw8kBVFqRA2TukO1ftNYuIc46zttioam/MAD9jsi1rQZoBIeTzkdU4zexvLdEfYdU
	 eqTp5rjkafIEwmz5o51OCoQ4oNcnF4MdYDxad7bgy++TiTWafm9wPB4eJq7O1r817hG2z
	 ItfjyPlUWO6zSR+eATcTTJTg9aJ65lFu8vkhtjwLqK91amAS2oG/41/QcA19bGjGjnAmz
	 QobHXzCTDIf+TfCAtTIBtqDs5TuMVtlrFuUQGNZZdq4XjJxMiGC/RdXX81xHGcHBM1eiA
	 ocSqlmfrVkGGi9RNb8I9W8WPpcKWjTSzClijmMq/vAHryS94PCgEJzFVnyHhfEjUY9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d4CX7QLs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F40F606A32A;
	Wed, 18 Nov 2026 20:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d4CX7QLs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EC81F000C4;
	Wed, 18 Nov 2026 20:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034818;
	bh=SCaChbcS1b0Vx9mQ05V+dwO5lV79UtNnqTtwfqQ8/es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4CX7QLskwLHRpDH94W42lV2ftaIoYqXgSgmqMog0GdY628YlEpugdgqXZDvwwH3O
	 R4TYw+RhQfEyXmQ+vG7YCUDc3rgeS099V6bXMrHiPHASPyuNNNwgQcLwqvDIJfxVIJ
	 9vtssR1tyVDj96xn5SWY9BZWE+9B2rjP2+087W3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Lipski <ivan.lipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0505/3318] drm/amd/display: Bump frame warning limit for clang builds of dml
Date: Wed, 18 Nov 2026 15:18:47 +0100
Message-ID: <20261118150332.235797441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Lipski <ivan.lipski@amd.com>

[ Upstream commit 18779dd84515db093fedb4ebaf0998c9b165a5fb ]

[Why&How]
When building the DML files with clang without any sanitizer or LTO,
the following -Wframe-larger-than errors break the build under
CONFIG_WERROR:

  display_mode_vba_30.c: error: stack frame size (2512) exceeds limit
    (2048) in 'dml30_ModeSupportAndSystemConfigurationFull'
  display_mode_vba_31.c: error: stack frame size (2416) exceeds limit
    (2048) in 'dml31_ModeSupportAndSystemConfigurationFull'
  display_mode_vba_314.c: error: stack frame size (2392) exceeds limit
    (2048) in 'dml314_ModeSupportAndSystemConfigurationFull'

Clang consistently spills more than gcc, pushing the frame past the 2048
byte limit.

Apply an existing approach of increasing the warn stack size to the
non-sanitizer path so plain clang builds use a 3072 byte limit.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5642
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 21711b6e66bb7b41b1aec67b2d99aafe768c8fcb)
Cc: stable@vger.kernel.org
[ sashal: Adapted the change to this tree's flat frame_warn_flag Makefile layout by nesting a clang check inside the existing else branch, with one extra endif. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile b/drivers/gpu/drm/amd/display/dc/dml/Makefile
index 0ba9a7997d561..6f0c96919d921 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -64,9 +64,13 @@ ifneq ($(CONFIG_FRAME_WARN),0)
 ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
 frame_warn_flag := -Wframe-larger-than=3072
 else
+ifeq ($(CONFIG_CC_IS_CLANG),y)
+frame_warn_flag := -Wframe-larger-than=3072
+else
 frame_warn_flag := -Wframe-larger-than=2048
 endif
 endif
+endif
 
 CFLAGS_$(AMDDALPATH)/dc/dml/display_mode_lib.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/display_mode_vba.o := $(dml_ccflags)
-- 
2.53.0



