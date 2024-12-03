Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC811EE00B;
	Tue,  3 Dec 2024 16:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242644; cv=none; b=thPY18bIDqD1u6LINobiq5T0zD6QWMdmZPpArb0Cio/qF42RPmHRRUjR8tl9B2RQRuc15Vf7BSdqofCJ3EQmwHlnHj+OofZsLN+igOfhbrl6wI9ZzH8uq64M8bnEZa83hiAgsSpG2d2u6tMOLpxrwMqvPeyY+48CegtdOVil5d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242644; c=relaxed/simple;
	bh=l/0D3+Bmlu0fNpXyWjEbBqjIYNiwDCpdDx/9pI4kZSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKDuF5HzJ96Xonc9fs1ui6jkax78/MvQZm/upNH1vuWiY4tN5/fUUjJS8/1SbQIhwgq4IkJUVBgpCHKXU6ZBTKDw40Rz4yMgQ9qQ4G/ylGwsbt85TZGetdNdDFjgcO7AAl9WqosNpLy0h3vhg0kwLLf9C2kMIYTzMGk6+lMzbxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVacH/RY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVacH/RY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB88C4CECF;
	Tue,  3 Dec 2024 16:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242644;
	bh=l/0D3+Bmlu0fNpXyWjEbBqjIYNiwDCpdDx/9pI4kZSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVacH/RYGa9wrV5vfctVJPAx5QO6+GJnXHEi5yGJBvK6NC939wkkWGgvnDspSK7sP
	 cNmEGSyQBdNpQnBRNQA2RgSiRjI7A6puOoexXhZhqdZgRI7s0QegZpg8JuBaLmDDJn
	 dRgHDV62vgF1JKXCzGs6L/4+Pnx8Olvsw9VDQKCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 766/826] lib: string_helpers: silence snprintf() output truncation warning
Date: Tue,  3 Dec 2024 15:48:13 +0100
Message-ID: <20241203144813.647105465@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit a508ef4b1dcc82227edc594ffae583874dd425d7 upstream.

The output of ".%03u" with the unsigned int in range [0, 4294966295] may
get truncated if the target buffer is not 12 bytes. This can't really
happen here as the 'remainder' variable cannot exceed 999 but the
compiler doesn't know it. To make it happy just increase the buffer to
where the warning goes away.

Fixes: 3c9f3681d0b4 ("[SCSI] lib: add generic helper to print sizes rounded to the correct SI range")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kees Cook <kees@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/r/20241101205453.9353-1-brgl@bgdev.pl
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/string_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -57,7 +57,7 @@ int string_get_size(u64 size, u64 blk_si
 	static const unsigned int rounding[] = { 500, 50, 5 };
 	int i = 0, j;
 	u32 remainder = 0, sf_cap;
-	char tmp[8];
+	char tmp[12];
 	const char *unit;
 
 	tmp[0] = '\0';


