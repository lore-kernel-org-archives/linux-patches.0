Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B73251C53;
	Mon, 11 Dec 2023 18:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOSKfmzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74EAC433C8;
	Mon, 11 Dec 2023 18:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319826;
	bh=VXw9Bli5bYbwjTD12tBM4zC6OHZ4Tt4x1DB48KZ7sEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOSKfmzcEmehguwpNhgrksk2UMgCdw3l+gMmj4Ur3CAMVPSDLVx8ZbwRoK3GMNGnS
	 B5eXM0AAPaaq7w55/ZY98uWAGmmyezQazMq1RxTCoUApL4V9+Ej+Xrk1rolAYQ67Bt
	 mhDJzgXigSKOkrqgbv//FGc+tf1nm/oiK8PTV3qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.6 240/244] gcc-plugins: randstruct: Update code comment in relayout_struct()
Date: Mon, 11 Dec 2023 19:22:13 +0100
Message-ID: <20231211182056.775314401@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit d71f22365a9caca82d424f3a33445de46567e198 upstream.

Update code comment to clarify that the only element whose layout is
not randomized is a proper C99 flexible-array member. This update is
complementary to commit 1ee60356c2dc ("gcc-plugins: randstruct: Only
warn about true flexible arrays")

Signed-off-by: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/ZWJr2MWDjXLHE8ap@work
Fixes: 1ee60356c2dc ("gcc-plugins: randstruct: Only warn about true flexible arrays")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -339,8 +339,7 @@ static int relayout_struct(tree type)
 
 	/*
 	 * enforce that we don't randomize the layout of the last
-	 * element of a struct if it's a 0 or 1-length array
-	 * or a proper flexible array
+	 * element of a struct if it's a proper flexible array
 	 */
 	if (is_flexible_array(newtree[num_fields - 1])) {
 		has_flexarray = true;


