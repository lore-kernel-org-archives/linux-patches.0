Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9FD448B95;
	Thu, 30 Jul 2026 16:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428198; cv=none; b=OeQ2tEFIzm99ZAjNVTjATmtNcjKX4VsmcHG0wq8sGzKQsE/fQmCtKgM4p7UXNDiL96DT0E2v/+QMELRMATE9SWzPhoxRuHbutm8EmGs+5FUefuA1fl33xLZe7g6o4peMx/pfm1QMO5Z0N7MW8GDheBYwMbeaVoMrBbcyUMqFpWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428198; c=relaxed/simple;
	bh=EALw2c4+/XOOncleEMD22x5hife+IYQyvMcryFkb+uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4uxKPW+7E6UzxYpPC4yVHX41QnVH3zqAEQXasvhXPfCTg69egMxbOd+uE6Euyw+KPZycc0KHZUyYqY5YF910Oh+FdXDY6AOrgTvrKwnjEGpEheR9CGY4lrTas1b7TW9vJZ28VcyPJCdGTh5pv873fTwZh7EiDBVZUrW6dqxT6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gL02jt2j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gL02jt2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD9B1F000E9;
	Thu, 30 Jul 2026 16:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428193;
	bh=2WJTcSV0FFnctvh/dPdsBTunn3oXsUl4t87dGa0ZMs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gL02jt2jcPcis39onnFK9AKBRa/OPz2d0sLsJz8jlZCPKi6gEQ8FneqpAgAHxk0rw
	 V9JQhsslA0gdhwuODTBI5Q0T0A3bB53DJkbFIv9l+5ePZ/1M8UM2rfHVfM6+5j89qG
	 0CkFFkC6xB1LGp7zNTsf6hSCyVsMZw376ZmfI2SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 436/484] thunderbolt: Update property.c function documentation
Date: Thu, 30 Jul 2026 16:15:33 +0200
Message-ID: <20260730141432.951881420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

[ Upstream commit d015642ad36d78e6eba12d8ab96cea6fd4602b49 ]

Make property.c function documentation compliant with current kernel-doc
standards. No functional changes.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 2c5d2d3c3f70 ("thunderbolt: Prevent XDomain delayed work use-after-free on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/property.c |   38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -231,11 +231,13 @@ static struct tb_property_dir *__tb_prop
  *
  * This function parses the XDomain properties data block into format that
  * can be traversed using the helper functions provided by this module.
- * Upon success returns the parsed directory. In case of error returns
- * %NULL. The resulting &struct tb_property_dir needs to be released by
+ *
+ * The resulting &struct tb_property_dir needs to be released by
  * calling tb_property_free_dir() when not needed anymore.
  *
  * The @block is expected to be root directory.
+ *
+ * Return: Pointer to &struct tb_property_dir, %NULL in case of failure.
  */
 struct tb_property_dir *tb_property_parse_dir(const u32 *block,
 					      size_t block_len)
@@ -258,6 +260,8 @@ struct tb_property_dir *tb_property_pars
  *
  * Creates new, empty property directory. If @uuid is %NULL then the
  * directory is assumed to be root directory.
+ *
+ * Return: Pointer to &struct tb_property_dir, %NULL in case of failure.
  */
 struct tb_property_dir *tb_property_create_dir(const uuid_t *uuid)
 {
@@ -501,9 +505,11 @@ static ssize_t __tb_property_format_dir(
  * @block_len: Length of the property block
  *
  * This function formats the directory to the packed format that can be
- * then send over the thunderbolt fabric to receiving host. Returns %0 in
- * case of success and negative errno on faulure. Passing %NULL in @block
- * returns number of entries the block takes.
+ * then sent over the thunderbolt fabric to receiving host.
+ *
+ * Passing %NULL in @block returns number of entries the block takes.
+ *
+ * Return: %0 on success, negative errno otherwise.
  */
 ssize_t tb_property_format_dir(const struct tb_property_dir *dir, u32 *block,
 			       size_t block_len)
@@ -525,9 +531,9 @@ ssize_t tb_property_format_dir(const str
  * tb_property_copy_dir() - Take a deep copy of directory
  * @dir: Directory to copy
  *
- * This function takes a deep copy of @dir and returns back the copy. In
- * case of error returns %NULL. The resulting directory needs to be
- * released by calling tb_property_free_dir().
+ * The resulting directory needs to be released by calling tb_property_free_dir().
+ *
+ * Return: Pointer to &struct tb_property_dir, %NULL in case of failure.
  */
 struct tb_property_dir *tb_property_copy_dir(const struct tb_property_dir *dir)
 {
@@ -597,6 +603,8 @@ err_free:
  * @parent: Directory to add the property
  * @key: Key for the property
  * @value: Immediate value to store with the property
+ *
+ * Return: %0 on success, negative errno otherwise.
  */
 int tb_property_add_immediate(struct tb_property_dir *parent, const char *key,
 			      u32 value)
@@ -626,6 +634,8 @@ EXPORT_SYMBOL_GPL(tb_property_add_immedi
  * @buflen: Number of bytes in the data buffer
  *
  * Function takes a copy of @buf and adds it to the directory.
+ *
+ * Return: %0 on success, negative errno otherwise.
  */
 int tb_property_add_data(struct tb_property_dir *parent, const char *key,
 			 const void *buf, size_t buflen)
@@ -662,6 +672,8 @@ EXPORT_SYMBOL_GPL(tb_property_add_data);
  * @text: String to add
  *
  * Function takes a copy of @text and adds it to the directory.
+ *
+ * Return: %0 on success, negative errno otherwise.
  */
 int tb_property_add_text(struct tb_property_dir *parent, const char *key,
 			 const char *text)
@@ -696,6 +708,8 @@ EXPORT_SYMBOL_GPL(tb_property_add_text);
  * @parent: Directory to add the property
  * @key: Key for the property
  * @dir: Directory to add
+ *
+ * Return: %0 on success, negative errno otherwise.
  */
 int tb_property_add_dir(struct tb_property_dir *parent, const char *key,
 			struct tb_property_dir *dir)
@@ -736,8 +750,10 @@ EXPORT_SYMBOL_GPL(tb_property_remove);
  * @key: Key to look for
  * @type: Type of the property
  *
- * Finds and returns property from the given directory. Does not recurse
- * into sub-directories. Returns %NULL if the property was not found.
+ * Finds and returns property from the given directory. Does not
+ * recurse into sub-directories.
+ *
+ * Return: Pointer to &struct tb_property, %NULL if the property was not found.
  */
 struct tb_property *tb_property_find(struct tb_property_dir *dir,
 	const char *key, enum tb_property_type type)
@@ -757,6 +773,8 @@ EXPORT_SYMBOL_GPL(tb_property_find);
  * tb_property_get_next() - Get next property from directory
  * @dir: Directory holding properties
  * @prev: Previous property in the directory (%NULL returns the first)
+ *
+ * Return: Pointer to &struct tb_property, %NULL if property was not found.
  */
 struct tb_property *tb_property_get_next(struct tb_property_dir *dir,
 					 struct tb_property *prev)


