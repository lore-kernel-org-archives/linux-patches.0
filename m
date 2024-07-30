Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4351A76BE;
	Tue, 30 Jul 2024 17:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360566; cv=none; b=dP6VMyB+eaq9NTr38o+PnZwkGoV1qWCXaFGC3beVhyfq+NQbOC6XJpnWuxjhxn90rPQ4WX7P7F5Aw+OMZaTvlBpK7IPrWoBMYZun9lpJO1RYEaeuf+xOkQEe0+M4JkkdGSIDwncW1yKbAqHa0ToshXf4xq6or7BYqSeFoWbac1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360566; c=relaxed/simple;
	bh=XueRPMNswUv+Vw1S1lT7p5YQzBgW4PpRscGDmk7DlTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6aTuEssQTIUYxwN8zWhtWJo3Tx5pogZNplVPAO7ZxJ8hjGGB/pELcGt81paMNMNtB1cYgNFkoUrYE8gffGzh1D78rlcuKed1dhaoxFv/LpVBZSg+i0z84INiXWJGupAAJwXyrejyjp8b9WDAuhQVdG8ySM3vjBRmM2vjA+SWpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSqKev9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSqKev9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D004CC32782;
	Tue, 30 Jul 2024 17:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360566;
	bh=XueRPMNswUv+Vw1S1lT7p5YQzBgW4PpRscGDmk7DlTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSqKev9z0oK+2SpA2nKbPbRTo1WpDgVWzEG3SxMvtn2SCZgbJFqV8EKE8P52InyMs
	 Oa2bH6KyQYE7aAaKIP1Tp7+yD+VEoqOU6/ppWZUivHGRa4hNUBAJfVwXDRRuznJqHO
	 GrTLMGc3CZMvN8lGeoblM8tsS7Wt0eSUMiD6vqqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 739/809] kdb: Use the passed prompt in kdb_position_cursor()
Date: Tue, 30 Jul 2024 17:50:15 +0200
Message-ID: <20240730151754.137919043@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit e2e821095949cde46256034975a90f88626a2a73 ]

The function kdb_position_cursor() takes in a "prompt" parameter but
never uses it. This doesn't _really_ matter since all current callers
of the function pass the same value and it's a global variable, but
it's a bit ugly. Let's clean it up.

Found by code inspection. This patch is expected to functionally be a
no-op.

Fixes: 09b35989421d ("kdb: Use format-strings rather than '\0' injection in kdb_read()")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240528071144.1.I0feb49839c6b6f4f2c4bf34764f5e95de3f55a66@changeid
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 7da3fa7beffd0..6a77f1c779c4c 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -206,7 +206,7 @@ char kdb_getchar(void)
  */
 static void kdb_position_cursor(char *prompt, char *buffer, char *cp)
 {
-	kdb_printf("\r%s", kdb_prompt_str);
+	kdb_printf("\r%s", prompt);
 	if (cp > buffer)
 		kdb_printf("%.*s", (int)(cp - buffer), buffer);
 }
-- 
2.43.0



